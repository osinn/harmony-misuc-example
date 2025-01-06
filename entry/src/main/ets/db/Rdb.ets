// import dataRdb from '@ohos.data.rdb' //原模块名
//import relationalStore from '@ohos.data.relationalStore';
import { relationalStore } from '@kit.ArkData';

//导入relationalStore模块，这个模块提供了操作关系型数据库的API。

class Rdb {
  rdbStore: relationalStore.RdbStore | null = null
  private sqlCreateTable: string = ''
  //STORE_CONFIG是一个配置对象，定义了数据库的名称（my.db）和安全级别（1）。
  private STORE_CONFIG: relationalStore.StoreConfig = { name: 'RdbMusic.db', securityLevel: 1 }
  private sqlCreateTableArray: Array<string> = [
    'CREATE TABLE IF NOT EXISTS dict('
      + 'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      + 'dictKey TEXT NOT NULL, '
      + 'dictValue TEXT)'
  ]

  // getRdbStore是一个异步方法，用于获取或创建数据库实例
  async initDb(context: Context) {

    if (this.rdbStore == null) {
      console.info("初始化数据库表222=====>", context);
      try {
        let getPromiseRdb = relationalStore.getRdbStore(context, this.STORE_CONFIG);
        await getPromiseRdb.then(async (rdbStore) => {
          this.rdbStore = rdbStore;
          console.info("初始化数据库表=====>", rdbStore);
          // 创建表，
          //
          //
          // catch用于处理错误情况，打印错误信息
          // rdbStore.executeSql(this.sqlCreateTable);
          for (let sqlCreateTableArrayElement of this.sqlCreateTableArray) {
            rdbStore.executeSql(sqlCreateTableArrayElement);
          }
        }).catch((err: string) => {
          console.log("初始化数据库错误 err." + JSON.stringify(err));
        });
      } catch (e) {
        console.log("初始化数据库错误" + e);
      }
    }


    // if (this.rdbStore != null) {
    //   for (let sqlCreateTableArrayElement of this.sqlCreateTableArray) {
    //     this.rdbStore.executeSql(sqlCreateTableArrayElement);
    //   }
    // }
  }
}

export default new Rdb()