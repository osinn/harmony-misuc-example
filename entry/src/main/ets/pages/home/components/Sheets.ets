
import { SkinTheme } from '../../../core/Theme'
import DictDao from '../../../db/DictDao'
import {SheetConstants} from '../../../db/SheetEntity'
import SheetListItem from '../../../components/base/SheetListItem'
import CreateMusicSheetPanel from '../../../components/panels/CreateMusicSheetPanel'

@Component
export struct Sheets {

  @State theme: SkinTheme.Theme = SkinTheme.getTheme();
  @State currentIndex: number = 0;
  @State isPresent: boolean = false;
  private dictTableDao = DictDao
  // 歌单key
  @Provide musicSheetKey: string = SheetConstants.MY_MUSIC_SHEET_KEY;

  @Builder
  tabBuilder(index: number, name: string, musicNumb: number = 0) {
    Row() {
      Column() {
        Text(name)
          .fontColor(this.theme.fontColor)
          .margin({ bottom: 5 })
          .onClick(() => {
            this.currentIndex = index;
          })
        Divider()
          .width('100%')
          .strokeWidth(2)
          .color(this.theme.dividerColor)
          .opacity(this.currentIndex === index ? 1 : 0)
      }
      .width('70vp')
      .height('30vp')

      Column() {
        Text(`(${musicNumb})`)// .lineHeight(7)
          .fontSize(12)
          .fontColor(this.theme.fontColor)
      }
      .height('30vp')
    }
    .margin({ left: '15vp' })

  }

  build() {
    Row() {
      Column() {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Column() {
            Row() {
              this.tabBuilder(0, '我的歌单', 10)

              this.tabBuilder(1, '收藏歌单')
            }
            .margin({ top: 5 })

            ///-------

          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
          .height('30vp')
          // .backgroundColor("#E6A23C")

          // 新建歌单、导入歌单
          Column() {
            Row() {

              // 新建歌单
              Image($r("app.media.ic_plus"))
                .width('20vp')
                .height('18vp')
                .fillColor(this.theme.iconColor)
                .margin({ right: '10vp' })
                .onClick(async () => {
                  this.musicSheetKey = this.currentIndex === 0 ? SheetConstants.MY_MUSIC_SHEET_KEY : SheetConstants.COLLECT_MUSIC_SHEET_KEY
                  const d = await this.dictTableDao.queryDictByKey(this.musicSheetKey);
                  console.log("字典",JSON.stringify(d))
                  this.isPresent = true
                })

              // 导入歌单
              Image($r("app.media.ic_arrow_down_and_rectangle_on_rectangle"))
                .width('20vp')
                .height('18vp')
                .margin({ right: '10vp' })
                .fillColor(this.theme.iconColor)
                .onClick(async  e => {
                   console.log('user', "获取用户字典：")
                })

            }

            .height('30vp')
          }
          // .flexBasis(200)
          .width(100)
          .height('100%')
          // .backgroundColor("#343434")
          .alignItems(HorizontalAlign.End)
          .justifyContent(FlexAlign.End)
        }
        // .backgroundColor("#E6A23C")
        .width('100%')
        .height('30vp')

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Column() {
            // 列表
            SheetListItem()
          }
          .height('100%')
          .width('100%')
          // .alignItems(HorizontalAlign.Center)
          // .justifyContent(FlexAlign.Center)
        }
        .height('100%')
        .width('100%')
        // .backgroundColor("#67C23A")
        CreateMusicSheetPanel({isPresent: this.isPresent})
          .width(0)
          .height(0)
      }
      .width('100%')
      .height('100%')
    }
  }
}