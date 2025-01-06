import { relationalStore } from '@kit.ArkData'; //用于操作关系型数据库
import promptAction from '@ohos.promptAction'; //用于显示提示信息
import rdb from './Rdb'
import { DictEntity } from './DictEntity'
import { ArrayList } from '@kit.ArkTS'; //用于存储和管理用户列表

class DictDao {
  //DictDao 类初始化时，设置表名、列名、创建表的SQL语句，并创建 Rdb 实例来管理数据库连接。
  private tableName: string = ''
  private columns: Array<string> = []
  private sql_create_table = ''

  constructor() {
    this.tableName = 'dict'
    this.columns = ['id', 'dictKey', 'dictValue']
  }

  // 插入数据
  insertDict(dict: DictEntity) {
    const valueBucket: relationalStore.ValuesBucket = JSON.parse(JSON.stringify(dict));
    if (rdb?.rdbStore != null) {
      rdb.rdbStore.insert(this.tableName, valueBucket, (err, ret) => {
        console.log('insert done: ' + ret);
        promptAction.showToast({ message: '添加成功' });
      });
    }
  }

  // 插入数据
  insert(key:string, value?:string) {
    let dictEntity = new DictEntity( key, value );
    const valueBucket: relationalStore.ValuesBucket = JSON.parse(JSON.stringify(dictEntity));
    if (rdb?.rdbStore != null) {
      rdb.rdbStore.insert(this.tableName, valueBucket, (err, ret) => {
        console.log('insert done: ' + ret);
        promptAction.showToast({ message: '添加成功' });
      });
    }
  }

  // 根据用户名查询用户信息
  async queryDictByKey(dictKey: string) {
    try {
      let resultList: ArrayList<DictEntity> | null = null;
      let predicates = new relationalStore.RdbPredicates(this.tableName);
      predicates.equalTo('dictKey', dictKey);
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

  // 查询全部用户信息
  async queryDictAll() {
    let resultList: ArrayList<DictEntity> | null = null;
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
      let promiseQuery = rdb.rdbStore.query(predicates, this.columns);
      await promiseQuery.then((resultSet) => {
        resultList = resultSet;
      }).catch((err: object) => {
        console.log("query err" + JSON.stringify(err));
      });
    }
    return resultList;
  }

  // 将查询到的结果封装用户列表
  getListFromResultSet(resultSet: relationalStore.ResultSet) {
    let DictList: ArrayList<DictEntity> = new ArrayList<DictEntity>();
    for (let i = 0; i < resultSet.rowCount; i++) {
      resultSet.goToNextRow();
      let Dict = new DictEntity(
        resultSet.getString(resultSet.getColumnIndex('dictKey')),
        resultSet.getString(resultSet.getColumnIndex('dictValue')),
        resultSet.getLong(resultSet.getColumnIndex('id')));
      DictList.add(Dict);
    }
    return DictList;
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
  updateDict(dict: DictEntity) {
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

export default new DictDao()
