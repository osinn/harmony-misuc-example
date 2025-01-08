import { relationalStore } from '@kit.ArkData'; //用于操作关系型数据库
import { emitter } from '@kit.BasicServicesKit';
import { SheetEntity, SheetConstants } from './SheetEntity'
import rdb from './Rdb'
import Toast from '../core/Toast'

emitter.once('musicSheetPanelDeleteItem', async  (eventData : emitter.EventData) => {
  if (eventData?.data?.deleteItem) {
    await sheetDao.delete(eventData?.data?.sheetKey, eventData?.data?.deleteItem?.title);
    Toast.success("删除成功")
    emitter.emit('createMusicSheetPanel', {data: {updateData: true}})
  }
});
class SheetDao {
  //DictDao 类初始化时，设置表名、列名、创建表的SQL语句，并创建 Rdb 实例来管理数据库连接。
  private tableName: string = ''
  private columns: Array<string> = []

  constructor() {
    this.tableName = 'sheet'
    this.columns = ['id', 'sheetKey', 'title', 'numb', 'imageCover', 'sort']
  }

  async intiDefaultSheet() {
    const musicSheet = await this.querySheetByKeyAndTitle(SheetConstants.MY_MUSIC_SHEET_KEY, "我喜欢")
    if (musicSheet == null) {
      await this.insert(SheetConstants.MY_MUSIC_SHEET_KEY, "我喜欢", 0, undefined, 99999999);
    }
  }

  // 插入数据
  async insert(sheetKey:string, title: string, numb: number = 0, imageCover?: string,  sort: number = 1) {
    let sheetEntity = new SheetEntity( sheetKey, title, numb, imageCover, sort );
    const valueBucket: relationalStore.ValuesBucket = JSON.parse(JSON.stringify(sheetEntity));
    if (rdb?.rdbStore != null) {
      await rdb.rdbStore.insert(this.tableName, valueBucket);
    }
  }

  // 根据歌单目录key查询歌单目录信息
  async querySheetByKey(sheetKey: string) {
    let resultList: Array<SheetEntity> = new Array<SheetEntity>();
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
      let resultList: Array<SheetEntity> | null = null;
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
    let resultList: Array<SheetEntity> | null = null;
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
      predicates.orderByDesc('sort')
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
    let sheetList: Array<SheetEntity> = new Array<SheetEntity>();
    for (let i = 0; i < resultSet.rowCount; i++) {
      if (resultSet.goToNextRow()) {
        let sheetEntity = this.geFromResult(resultSet);
        sheetList.push(sheetEntity);
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
      rdb.rdbStore.update(valueBucket, predicates);
    }
  }

  // 删除数据
  deleteById(id: number) {
    let predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('id', id);
    if (rdb?.rdbStore != null) {
      rdb.rdbStore.delete(predicates);
    }
  }
  async  delete(sheetKey: string, title?: string) {
    let predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('sheetKey', sheetKey);
    if (title) {
      predicates.and().equalTo('title', title)
    }
    if (rdb?.rdbStore != null) {
      await rdb.rdbStore.delete(predicates);
    }
  }
}
const sheetDao = new SheetDao();
export default sheetDao
