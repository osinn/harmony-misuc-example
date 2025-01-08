// import dataRdb from '@ohos.data.rdb' //原模块名
//import relationalStore from '@ohos.data.relationalStore';
import { relationalStore, ValuesBucket } from '@kit.ArkData';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { Constants } from './DBConstants'
import DataService from './DataService'
import { logger } from '../core/Logger';

//导入relationalStore模块，这个模块提供了操作关系型数据库的API。

const STORE_CONFIG: relationalStore.StoreConfig = {
  name: Constants.DB_FILE_NAME,
  securityLevel: relationalStore.SecurityLevel.S1
};

class Rdb {
  rdbStore: relationalStore.RdbStore | undefined = undefined;
  //STORE_CONFIG是一个配置对象，定义了数据库的名称（my.db）和安全级别（1）。
  // private STORE_CONFIG: relationalStore.StoreConfig = { name: 'RdbMusic.db', securityLevel: 1 }
  private sqlCreateTableArray: Array<string> = [
  // 字典表
    'CREATE TABLE IF NOT EXISTS ' + Constants.SQL_TABLE_NAME[0] + '('
      + 'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      + 'dictKey TEXT NOT NULL, '
      + 'dictValue TEXT)',

    // sheet
    'CREATE TABLE IF NOT EXISTS ' + Constants.SQL_TABLE_NAME[1] + '('
      + 'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      + 'sheetKey TEXT NOT NULL, '
      + 'title TEXT NOT NULL,'
      + 'numb INTEGER,'
      + 'imageCover TEXT,'
      + 'sort INTEGER'+
      ')'
  ]

  // getRdbStore是一个异步方法，用于获取或创建数据库实例
  async initDb(context: Context) {

    if (this.rdbStore === undefined || this.rdbStore == null) {
      try {
        // let getPromiseRdb = relationalStore.getRdbStore(context, this.STORE_CONFIG);
        // await getPromiseRdb.then(async (rdbStore) => {
        //   this.rdbStore = rdbStore;
        //   console.info("初始化数据库表=====>", rdbStore);
        //   // 创建表，
        //   //
        //   //
        //   // catch用于处理错误情况，打印错误信息
        //   // rdbStore.executeSql(this.sqlCreateTable);
        //   for (let sqlCreateTableArrayElement of this.sqlCreateTableArray) {
        //     rdbStore.executeSql(sqlCreateTableArrayElement);
        //   }
        // }).catch((err: string) => {
        //   console.log("初始化数据库错误 err." + JSON.stringify(err));
        // });

        // let getPromiseRdb = relationalStore.getRdbStore(context, STORE_CONFIG);
        // await getPromiseRdb.then(async (rdbStore) => {
        //   console.log("初始化数据");
        //   this.rdbStore = rdbStore;
        //
        //   // await this.dropTable('dict', Constants.V1);
        //   // await this.dropTable('sheet', Constants.V1);
        //     for (let sqlCreateTableArrayElement of this.sqlCreateTableArray) {
        //       rdbStore.executeSql(sqlCreateTableArrayElement);
        //     }
        //
        //   // await this.batchInsert(Constants.STUDENT_TABLE, Constants.students);
        //   // await this.checkUpdateVersion();
        // }).catch((err: string) => {
        //   console.log("初始化数据库错误 err." + JSON.stringify(err));
        // });

        relationalStore.getRdbStore(context, STORE_CONFIG,
          async (err: BusinessError, rdbStore: relationalStore.RdbStore) => {
            console.log("初始化数据");
            this.rdbStore = rdbStore;
            if (err) {
              logger.error(`init DB failed, code is ${err.code}, message is ${err.message}`);
              return;
            }
            // await this.dropTable('dict', Constants.V1);
            // await this.dropTable('sheet', Constants.V1);
            await this.createTable();
            this.commit();
            // await this.batchInsert(Constants.STUDENT_TABLE, Constants.students);
            // 检查数据库升级
            await this.checkUpdateVersion();
          });

      } catch (e) {
        console.log("初始化数据库错误" + e);
      }
    }
  }

  commit(): void {
    if (this.rdbStore !== undefined) {
      this.rdbStore.commit();
    }
  }

  rollback(): void {
    if (this.rdbStore !== undefined) {
      this.rdbStore.rollBack();
    }
  }

  beginTransaction(): void {
    if (this.rdbStore !== undefined) {
      this.rdbStore.beginTransaction();
    }
  }

  getStoreVersion(): number {
    if (this.rdbStore !== undefined) {
      return this.rdbStore.version;
    }
    return -1;
  }

  async checkUpdateVersion() {
    const currentVersion = this.getStoreVersion();
    console.log("当前数据库版本号：" + currentVersion);
    logger.info("当前数据库版本号=====>" + currentVersion)
    if (currentVersion != Constants.V2) {
      console.log("准备将" + currentVersion + "版本升级到" + Constants.V2);
      await this.backup(currentVersion);
      await DataService.onUpgrade(currentVersion);

      // if (this.rdbStore) {
      //   this.rdbStore.version = Constants.V2;
      // }
    }
  }

  /**
   * 创建表
   *
   * @param tableName 表名
   */
  async createTable(): Promise<void> {
    if (this.rdbStore === undefined || this.rdbStore === null) {
      return;
    }
    try {
      for (let createTableSql of this.sqlCreateTableArray) {
        await this.rdbStore.executeSql(createTableSql);
      }
    } catch (err) {
      logger.error(`createTable failed,code is ${err.code}, message is ${err.message}`);
    }
  }

  /**
   * 删除表
   *
   * @param tableName 表名
   */
  async dropTable(tableName: string, targetVersion: number): Promise<void> {
    if (this.rdbStore === undefined) {
      return;
    }
    const deleteTableSql: string = util.format(Constants.DROP_TABLE_SQL_TEMPLATE, tableName);
    try {
      logger.info("删除表：：：" + deleteTableSql)
      await this.rdbStore.executeSql(deleteTableSql);
    } catch (err) {
      logger.error(`dropTable failed,code is ${err.code}, message is ${err.message}, the sql is ${deleteTableSql}`);
      return;
    }
  }

  /**
   * 删除rdbStore
   */
  deleteRdbStore(context: Context): void {
    if (this.rdbStore !== undefined) {
      relationalStore.deleteRdbStore(context, 'DatabaseUpgrade.db', (err) => {
        if (err) {
          logger.error('delete rdbStore failed');
        }
        this.rdbStore = undefined;
      });
    }
  }

  /**
   * 备份数据库
   * @param callback 版本升级方法
   * @param version 版本
   */
  async backup(version: number): Promise<void> {
    if (this.rdbStore !== undefined) {
      await this.rdbStore.backup(version + Constants.DB_FILE_NAME_SUFFIX);
    }
  }

  /**
   * 恢复数据库
   * @param callback 版本升级方法
   * @param version 版本
   */
  async restore(version: number): Promise<void> {
    if (this.rdbStore !== undefined) {
      await this.rdbStore.restore(version + Constants.DB_FILE_NAME_SUFFIX);
    }
  }

  /**
   * 修改表名
   *
   * @param oldTableName 旧表名
   * @param newTableName 新表名
   */
  async updateTableName(oldTableName: string, newTableName: string): Promise<void> {
    if (this.rdbStore !== undefined) {
      const updateTableSql: string = util.format(Constants.UPDATE_TABLE_SQL_TEMPLATE, oldTableName, newTableName);
      logger.info("修改表名：：：" + updateTableSql)
      try {
        await this.rdbStore.executeSql(updateTableSql);
      } catch (err) {
        logger.error(`updateTableName failed,code is ${err.code}, message is ${err.message}, the sql is ${updateTableSql}`);
      }
    }
  }

  /**
   * 批量插入数据
   * @param tableName 表名
   * @param data 数据
   * @returns 插入条数
   */
  async batchInsert(tableName: string, data: ValuesBucket[]): Promise<void> {
    if (this.rdbStore !== undefined) {
      await this.rdbStore.batchInsert(tableName, data);
    }
  }

  /**
   * 通用查询
   * @param tableName 表名
   * @param limit     最大查询数量
   * @param lastId    上一次查询id
   * @param callback  业务逻辑
   */
  async queryData(tableName: string, limit: number, lastId: number,
    callback: (result: relationalStore.ResultSet) => Promise<void>): Promise<void> {
    if (this.rdbStore === undefined) {
      return;
    }
    const querySql: string = util.format(Constants.QUERY_TABLE_SQL_TEMPLATE, tableName, lastId, limit);
    try {
      const resultSet = await this.rdbStore.querySql(querySql)
      await callback(resultSet);
      resultSet.close();
    } catch (err) {
      logger.error(`query failed, code is ${err.code}, message is ${err.message}`);
    }
  }
}

export default new Rdb()