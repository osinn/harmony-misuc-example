import { util } from '@kit.ArkTS'
import { SheetEntity } from '../../db/SheetEntity'
import { SkinTheme } from '../../core/Theme'

@Component
export default struct SheetListItem {
  // 歌单key
  @Consume musicSheetKey: string;
  @State theme: SkinTheme.Theme = SkinTheme.getTheme();
  private contacts: Array<SheetEntity> = [
    new SheetEntity(this.musicSheetKey, '我喜欢', 0, ''),
    new SheetEntity(this.musicSheetKey, '我的音乐', 0, ''),
  ]

  build() {
    List() {
      ForEach(this.contacts, (item: SheetEntity, index: number) => {
        ListItem() {
          Row() {
            if (index == 0) {
              Image($r("app.media.album_default"))
                .width('40vp')
                .height('40vp')
                .margin('10vp')
                .borderRadius(8)
            } else {
              Image($r("app.media.album_default"))
                .width('40vp')
                .height('40vp')
                .margin('10vp')
                .borderRadius(8)
            }

            Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
              Column({ space: 5 }) {
                Text(item.title)
                  .fontColor(this.theme.fontColor)
                  .fontSize('14fp')
                Text(`${item.numb ? item.numb : 0}首`)
                  .fontColor(this.theme.subtitleTextColor)
                  .fontSize('10fp')
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)

              if (index != 0) {
                Image($r("app.media.ic_trash_outline"))
                  .width('18vp')
                  .height('18vp')
                  .margin('10vp')
              }
            }
            .width('82%')


          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
        }
      }, (item: SheetEntity) => JSON.stringify(item))
    }
    .divider({ strokeWidth: 2 })
    .width('100%')
  }
}