import { util } from '@kit.ArkTS'
import { SheetEntity } from '../../db/SheetEntity'
import { SkinTheme } from '../../core/Theme'
import SheetDao from '../../db/SheetDao'
import { ArrayList } from '@kit.ArkTS'; //用于存储和管理歌单目录列表


@Component
export default struct SheetListItem {
  // 歌单key
  @Consume musicSheetKey: string;
  @State theme: SkinTheme.Theme = SkinTheme.getTheme();

  @State sheetList: Array<SheetEntity> = [
    new SheetEntity(this.musicSheetKey, '我喜欢', 0, '')
  ]

  async  aboutToAppear() {
    let resultList: ArrayList<SheetEntity> = await SheetDao.querySheetByKey(this.musicSheetKey)
    resultList.forEach(item => {
      this.sheetList.push(item)
    })
  }


  build() {
    List() {
      ForEach(this.sheetList, (item: SheetEntity, index: number) => {
        ListItem() {
          Row() {
            if (index == 0) {
              Image($r("app.media.album_default"))
                .width('40vp')
                .height('40vp')
                .margin('10vp')
                .borderRadius(8)

              Image($r("app.media.ic_heart"))
                .width('20vp')
                .height('20vp')
                .margin('10vp')
                .borderRadius(8)
                .fillColor('red')
                .position({top: '10vp', left: '10vp'})

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
          .position({bottom: 0, right: 0})
          .width('100%')
          .justifyContent(FlexAlign.Start)
        }
      }, (item: SheetEntity) => JSON.stringify(item))
    }
    .divider({ strokeWidth: 2 })
    .width('100%')
  }
}