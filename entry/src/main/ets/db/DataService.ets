/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import dbUtils from './Rdb'
import { Constants } from './DBConstants'
import SheetDao from './SheetDao'
import DictDao from './DictDao'
import { relationalStore, ValuesBucket } from '@kit.ArkData';

/**
 * 数据库版本升级基础业务层
 */
export abstract class BaseDataService {
  async onUpgrade(targetVersion: number): Promise<void> {
    // 开启事务
    dbUtils.beginTransaction();
    // 获取当前数据库版本
    const oldVersion: number = dbUtils.getStoreVersion();
    for (let tableName of Constants.SQL_TABLE_NAME) {
      // 将旧表改为临时表
      await dbUtils.updateTableName(tableName, tableName + oldVersion);
    }
    // 创建新表
    await dbUtils.createTable();
    dbUtils.commit();
    // 自定义迁移逻辑
    const LAST_ID: number = -1;
    const FLAG: boolean = false;
    for (let tableName of Constants.SQL_TABLE_NAME) {
      try {
        // 迁移数据到新表
        await this.migrate(tableName, LAST_ID, oldVersion, targetVersion, FLAG);
        dbUtils.commit();
      } catch (e) {
        console.log("数据迁移错误", e);
      }

      // 删除旧表
      await dbUtils.dropTable(tableName + oldVersion, targetVersion);
    }

    if (dbUtils.rdbStore) {
      // 设置数据库版本
      dbUtils.rdbStore.version = Constants.V2;
    }
  }

  /**
   * 递归方式批次查询旧表数据
   * @param lastId 上一次查询的最后一个id
   * @param targetVersion 目标版本
   */
  private async migrate(tableName: string, lastId: number, oldVersion: number, targetVersion: number,
    flag: boolean): Promise<void> {
    if (flag) {
      return;
    }
    let newDataArray: ValuesBucket[] = new Array();
    await dbUtils.queryData(tableName + oldVersion, Constants.MAX_BATCH_NUM, lastId, async (resultSet) => {
      if (resultSet.rowCount === 0) {
        flag = true;
        return;
      }
      // 对查询的旧表数据依次进行转换
      while (resultSet.goToNextRow()) {
        const newData = this.transform(tableName, resultSet, targetVersion);
        if (newData !== undefined) {
          newDataArray.push(newData);
          if (resultSet.isAtLastRow) {
            lastId = newData[Constants.ID_STR] as number;
            break;
          }
        }
      }
      if (newDataArray.length === 0) {
        return;
      }
      // 将转换后的数据存入新表
      await dbUtils.batchInsert(tableName, newDataArray);
      await this.migrate(tableName, lastId, oldVersion, targetVersion, flag);
    })
  }

  /**
   * TODO： 知识点： 新老版本字段转换逻辑（版本升级只需要实现这个方法即可）
   * @param resultSet 查询结果集
   * @param targetVersion 目标版本
   * @returns 目标版本格式数据
   */
  abstract transform(tableName: string, resultSet: relationalStore.ResultSet,
    targetVersion: number): ValuesBucket | undefined;
}

/**
 * V1版本升级数据处理业务层
 */
class DataService extends BaseDataService {
  /**
   * V1新老版本字段转换逻辑
   * @param resultSet 查询结果集
   * @param targetVersion 目标版本
   * @returns 目标版本格式数据
   */
  transform(tableName: string, resultSet: relationalStore.ResultSet, targetVersion: number): ValuesBucket | undefined {
    if (targetVersion !== Constants.V2) {
      return this.transformV1ToV2(tableName, resultSet);
    } else {
      return undefined;
    }
  }

  private transformV1ToV2(tableName: string, resultSet: relationalStore.ResultSet): ValuesBucket | undefined {
    if (tableName === Constants.SQL_TABLE_NAME[0]) {
      let dict = DictDao.geFromResult(resultSet);
      const newData: ValuesBucket = JSON.parse(JSON.stringify(dict));
      return newData;
    } else if (tableName === Constants.SQL_TABLE_NAME[1]) {
      let sheetEntity = SheetDao.geFromResult(resultSet);
      const newData: ValuesBucket = JSON.parse(JSON.stringify(sheetEntity));
      return newData;
    } else {
      return undefined;
    }
  }
}

export default new DataService()