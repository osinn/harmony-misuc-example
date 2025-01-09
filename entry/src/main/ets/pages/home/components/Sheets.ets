import { emitter } from '@kit.BasicServicesKit';
import { SkinTheme } from '../../../core/Theme'
import DictDao from '../../../db/DictDao'
import { SheetEntity, SheetConstants } from '../../../db/SheetEntity'
import SheetListItem from '../../../components/base/SheetListItem'
import {SheetMoveListItem, SheetMoveListItemController} from '../../../components/base/SheetMoveListItem'
import CreateMusicSheetPanel from '../../../components/panels/CreateMusicSheetPanel'
import SheetDao from '../../../db/SheetDao'
import { DialogConstants } from '../../../components/dialogs/UseDialog';
import { ListExchangeViewComponent } from "../../../components/base/listexchange/view/ListExchangeView";
@Component
export struct Sheets {
  @State theme: SkinTheme.Theme = SkinTheme.getTheme();
  @Watch('changeTabBuilder') @State currentIndex: number = 0;
  @State isPresent: boolean = false;
  private dictTableDao = DictDao
  // 歌单key
  @Provide musicSheetKey: string = SheetConstants.MY_MUSIC_SHEET_KEY;
  @Provide sheetList: Array<SheetEntity> = new Array<SheetEntity>();
  // 是否刷新拖拽列表数据
  @Provide refreshListExchangeViewComponent: boolean = false

  @State myMusicSheetNumb: number = 0;
  @State collectMusicSheetNumb: number = 0;

  private sheetMoveListItemChildRef = new SheetMoveListItemController()

  aboutToAppear() {
    // console.log("组件初始化")
    this.querySheet();
    emitter.on('createMusicSheetPanel', (eventData : emitter.EventData) => {
      if (eventData?.data?.updateData) {
        this.querySheet()
      }
    });
    emitter.on(DialogConstants.SHOW_DIALOG_CONFIRM_EVENT_ID, () => {
      this.querySheet()
    })
  }

  private changeTabBuilder () {
    this.musicSheetKey = this.currentIndex === 0 ? SheetConstants.MY_MUSIC_SHEET_KEY : SheetConstants.COLLECT_MUSIC_SHEET_KEY;
    this.querySheet();
  }

  private async querySheet() {
    // console.log("进来");
    let resultList: Array<SheetEntity> = await SheetDao.querySheetByKey(this.musicSheetKey)
    if (resultList && resultList.length > 0) {
      this.sheetList = JSON.parse(JSON.stringify(resultList))

      this.myMusicSheetNumb = this.currentIndex == 0 ? resultList.length : 0
      this.collectMusicSheetNumb = this.currentIndex == 1 ? resultList.length : 0
    } else {
      this.sheetList = [];
      this.myMusicSheetNumb = 0
      this.collectMusicSheetNumb = 0
    }
    // this.sheetList = [];
    // resultList.forEach(item => {
    //   this.sheetList.push(item)
    // })
    this.refreshListExchangeViewComponent = true;
  }

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
          .color(this.theme.tabDividerColor)
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
              // UI没有刷新数量？
              this.tabBuilder(0, '我的歌单', this.myMusicSheetNumb)

              this.tabBuilder(1, '收藏歌单', this.collectMusicSheetNumb)
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
                  console.log("字典", JSON.stringify(d))
                  this.isPresent = true
                })

              // 导入歌单
              Image($r("app.media.ic_arrow_down_and_rectangle_on_rectangle"))
                .width('20vp')
                .height('18vp')
                .margin({ right: '10vp' })
                .fillColor(this.theme.iconColor)
                .onClick(async e => {
                  const testData = await this.sheetMoveListItemChildRef.getSheetMoveListItemData();
                  console.log('user', "获取用户字典：" + JSON.stringify(testData))
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
            // SheetListItem()
            SheetMoveListItem({sheetList: this.sheetList, controller: this.sheetMoveListItemChildRef})
            // ListExchangeViewComponent({sheetList: this.sheetList})
          }
          .height('100%')
          .width('100%')

          // .alignItems(HorizontalAlign.Center)
          // .justifyContent(FlexAlign.Center)
        }
        .height('100%')
        .width('100%')

        // .backgroundColor("#67C23A")
        CreateMusicSheetPanel({ isPresent: this.isPresent })
          .width(0)
          .height(0)
      }
      .width('100%')
      .height('100%')
    }
  }
}