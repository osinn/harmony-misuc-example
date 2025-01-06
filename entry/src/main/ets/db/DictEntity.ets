export class DictEntity {
  id?: number
  dictKey: string;
  dictValue?: string;

  constructor(dictKey: string, dictValue?: string, id?: number) {
    this.id = id
    this.dictKey = dictKey;
    this.dictValue = dictValue;
  }

  toString() {
    return this.id + ' ' + this.dictKey + ' ' + this.dictValue+ '\n';
  }
}