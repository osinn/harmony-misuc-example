
export class Constants {
  static readonly SQL_TABLE_NAME: Array<string> = [
    // 字典表
    'dict',
    // 歌单目录表
    'sheet'
  ]
  static readonly MAX_BATCH_NUM: number = 100;
  // 当前数据库版本不等于此版本需要升级数据库
  static readonly V2: number = 2;
  static readonly DB_FILE_NAME_SUFFIX: string = '.db';
  static readonly UPDATE_TABLE_SQL_TEMPLATE: string = 'ALTER TABLE %s RENAME TO %s';
  static readonly DROP_TABLE_SQL_TEMPLATE: string = 'DROP TABLE IF EXISTS %s';
  static readonly DB_FILE_NAME: string = 'RdbMusic.db';
  static readonly QUERY_TABLE_SQL_TEMPLATE: string = 'SELECT * FROM %s WHERE id > %s limit %s';
  static readonly ID_STR: string = 'id';

  // static readonly V3: number = 3;
  // static readonly NUMBER_1: number = 1;
  // static readonly NUMBER_10: number = 10;
  // static readonly NUMBER_12: number = 12;
  // static readonly NUMBER_15: number = 15;
  // static readonly NUMBER_20: number = 20;
  // static readonly NUMBER_50: number = 50;
  // static readonly NUMBER_500: number = 500;
  // static readonly CREATE_TABLE_SQL_TEMPLATE: string = 'CREATE TABLE IF NOT EXISTS %s (id INTEGER PRIMARY KEY AUTOINCREMENT %s)';

  // static readonly ROLLBACK_SUCCESS: string = '回退成功';
  // static readonly UPDATE_SUCCESS: string = '更新成功';
  // static readonly COMMA: string = ',';
  // static readonly SPACE: string = ' ';
  // static readonly EMPTY_STRING: string = '';

  // static readonly STUDENT_TABLE: string = 'student';
  // static readonly DEFAULT_TEACHER_NAME: string = '李明';
  // static readonly DEFAULT_TEACHER_FIRST_NAME: string = '李';
  // static readonly TABLE_TITLE_PREFIX = '版本V';
  // static readonly PRODUCTION = '功能介绍:数据库版本升降级\n1、V1->V2: 删除了className字段，增加了teacherName字段\n2、V2->V3: 将teacherName字段更改为teacherFirstName字段\n3、V1->V3: 删除了className字段，增加了teacherFirstName字段';
  // static readonly students: ValuesBucket[] = [
  //   { 'id': 1, 'name': '张三', 'className': '一(1)班' },
  //   { 'id': 2, 'name': '李四', 'className': '一(1)班' },
  //   { 'id': 3, 'name': '王五', 'className': '一(2)班' },
  //   { 'id': 4, 'name': '赵六', 'className': '一(2)班' }
  // ];
  // static readonly V1_STUDENT_COLUMN_TYPE_MAP: string[][] = [
  //   ['name', 'TEXT'],
  //   ['className', 'TEXT']
  // ];
  // static readonly V2_STUDENT_COLUMN_TYPE_MAP: string[][] = [
  //   ['name', 'TEXT'],
  //   ['teacherName', 'TEXT']
  // ];
  // static readonly V3_STUDENT_COLUMN_TYPE_MAP: string[][] = [
  //   ['name', 'TEXT'],
  //   ['teacherFirstName', 'TEXT']
  // ];
}