import { util } from '@kit.ArkTS'
import { SheetEntity } from '../../db/SheetEntity'

@Component
export default struct SheetListItem {
  // 歌单key
  @Consume musicSheetKey: string;
  private contacts: Array<SheetEntity> = [
    new SheetEntity(this.musicSheetKey, '小明', 0, ''),
    new SheetEntity(this.musicSheetKey, '小红', 0, ''),
  ]

  build() {
    List() {
      ForEach(this.contacts, (item: SheetEntity) => {
        ListItem() {
          Row() {
            Image($r("app.media.album_default"))
              .width(40)
              .height(40)
              .margin(10)
            Text(item.title).fontSize(20)
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
        }
      }, (item: SheetEntity) => JSON.stringify(item))
    }
    .width('100%')
  }
}