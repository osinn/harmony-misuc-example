export class SheetEntity {
  id?: number
  sheetKey: string;
  title: string;
  numb?: number;
  imageCover?: string;
  sort?: number;

  constructor(sheetKey:string, title: string, numb?: number, imageCover?: string, sort?: number, id?: number) {
    this.id = id
    this.sheetKey = sheetKey;
    this.title = title;
    this.numb = numb;
    this.imageCover = imageCover;
    this.sort = sort;
  }

  toString() {
    return this.id + ' ' + this.sheetKey + ' ' + this.title + ' ' + this.numb + ' ' + this.imageCover + ' ' + this.sort + '\n';
  }
}

export class SheetConstants {

  /**
   * 我的歌单 key
   */
  static readonly MY_MUSIC_SHEET_KEY: string = 'myMusicSheetKey';

  /**
   * 收藏歌单 key
   */
  static readonly COLLECT_MUSIC_SHEET_KEY: string = 'collectMusicSheetKey';
}