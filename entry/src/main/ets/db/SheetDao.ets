import { relationalStore } from '@kit.ArkData'; //用于操作关系型数据库
import promptAction from '@ohos.promptAction'; //用于显示提示信息
import rdb from './Rdb'
import { SheetEntity } from './SheetEntity'
import { ArrayList } from '@kit.ArkTS'; //用于存储和管理歌单目录列表

class SheetDao {
  //DictDao 类初始化时，设置表名、列名、创建表的SQL语句，并创建 Rdb 实例来管理数据库连接。
  private tableName: string = ''
  private columns: Array<string> = []

  constructor() {
    this.tableName = 'sheet'
    this.columns = ['id', 'sheetKey', 'title', 'numb', 'imageCover', 'sort']
  }

  // 插入数据
  insert(sheetKey:string, title: string, numb: number = 0, imageCover?: string,  sort: number = 1) {
    let sheetEntity = new SheetEntity( sheetKey, title, numb, imageCover, sort );
    const valueBucket: relationalStore.ValuesBucket = JSON.parse(JSON.stringify(sheetEntity));
    if (rdb?.rdbStore != null) {
      rdb.rdbStore.insert(this.tableName, valueBucket, (err, ret) => {
        promptAction.showToast({ message: '添加成功' });
      });
    }
  }

  // 根据歌单目录key查询歌单目录信息
  async querySheetByKey(sheetKey: string) {
    let resultList: ArrayList<SheetEntity> = new ArrayList<SheetEntity>();
    try {
      let predicates = new relationalStore.RdbPredicates(this.tableName);
      predicates.equalTo('sheetKey', sheetKey);
      let ret = await this.queryFromDB(predicates);
      if (ret != null) {
        resultList = this.getListFromResultSet(ret);
      }
      return resultList;
    } catch (e) {
      console.log("查询异常", e)
    }
    return resultList;
  }

  // 根据歌单目录key查询歌单目录信息
  async querySheetByKeyAndTitle(sheetKey: string, title: string) {
    try {
      let resultList: ArrayList<SheetEntity> | null = null;
      let predicates = new relationalStore.RdbPredicates(this.tableName);
      predicates.equalTo('sheetKey', sheetKey).and().equalTo('title', title);
      let ret = await this.queryFromDB(predicates);
      if (ret != null) {
        resultList = this.getListFromResultSet(ret);
      }
      return resultList && resultList.length > 0 ? resultList[0] : null;
    } catch (e) {
      console.log("查询异常", e)
    }
    return null;
  }

  // 查询全部歌单目录信息
  async querySheetAll() {
    let resultList: ArrayList<SheetEntity> | null = null;
    let predicates = new relationalStore.RdbPredicates(this.tableName);
    let ret: relationalStore.ResultSet | null = await this.queryFromDB(predicates);

    if (ret != null) {
      resultList = this.getListFromResultSet(ret);
    }
    return resultList;
  }

  // 根据条件查询数据库
  async queryFromDB(predicates: relationalStore.RdbPredicates) {
    let resultList: relationalStore.ResultSet | null = null;
    if (rdb?.rdbStore != null) {
      // dbUtils.rdbStore.version = Constants.V2;
      console.log("版本号：",rdb.rdbStore.version)
      // predicates.orderByDesc('sort')
      let promiseQuery = rdb.rdbStore.query(predicates);
      await promiseQuery.then((resultSet) => {
        resultList = resultSet;
      }).catch((err: object) => {
        console.log("query err" + JSON.stringify(err));
      });
    }
    return resultList;
  }

  geFromResult(resultSet: relationalStore.ResultSet): SheetEntity {

    try {
      const columnNameList = resultSet.columnNames;
      let jsonObject: Record<string, Object> = {};
      for (let columnNameElement of columnNameList) {
        jsonObject[columnNameElement] = resultSet.getString(resultSet.getColumnIndex(columnNameElement));
      }
      let sheetEntity: SheetEntity = JSON.parse(JSON.stringify(jsonObject))
      return sheetEntity;
    } catch (e) {
      console.log("获取数据异常",e);
      throw new Error(e);
    }
  }

  // 将查询到的结果封装歌单目录列表
  getListFromResultSet(resultSet: relationalStore.ResultSet) {
    let sheetList: ArrayList<SheetEntity> = new ArrayList<SheetEntity>();
    for (let i = 0; i < resultSet.rowCount; i++) {
      if (resultSet.goToNextRow()) {
        let sheetEntity = this.geFromResult(resultSet);
        sheetList.add(sheetEntity);
      }
    }
    return sheetList;
  }

  // 删除全部数据
  async deleteAll() {
    let result: number = 0;
    let predicates = new relationalStore.RdbPredicates(this.tableName);
    if (rdb?.rdbStore != null) {
      await rdb.rdbStore.delete(predicates).then((rows) => {
        result = rows;
        promptAction.showToast({ message: '删除成功' });
      });
    }
    return result
  }

  // 更新数据
  updateDict(dict: SheetEntity) {
    const valueBucket: relationalStore.ValuesBucket = JSON.parse(JSON.stringify(dict));
    let predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('id', dict.id);
    if (rdb?.rdbStore != null) {
      rdb.rdbStore.update(valueBucket, predicates, (err, ret) => {
        promptAction.showToast({ message: '更新成功'});
      });
    }
  }

  // 删除数据
  deleteDictById(id: number) {
    let predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('id', id);
    if (rdb?.rdbStore != null) {
      rdb.rdbStore.delete(predicates, (err, rows) => {
        promptAction.showToast({ message: '删除成功' });
      });
    }
  }
}

export default new SheetDao()
