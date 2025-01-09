/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { emitter } from '@kit.BasicServicesKit';
import { ListExchange } from '../utils/ListExchange';
import { ListExchangeCtrl } from "../model/ListExchangeCtrl";
import { SheetEntity } from '../../../../db/SheetEntity';
import { SkinTheme } from '../../../../core/Theme';
import { DialogConstants, ShowDialog } from '../../../dialogs/UseDialog';
import SheetDao from '../../../../db/SheetDao';


const ITEM_HEIGHT: number = 50; // 列表项高度

/**
 * 功能说明: 本示例通过List组件、组合手势GestureGroup、swipeAction属性以及attributeModifier属性等实现了列表项的交换和删除。
 * 推荐场景: 扣款列表
 *
 * 核心组件:
 * 1. ListExchange: 自定义列表交换视图组件
 * 2. ListInfo: 设置列表项元素的类
 *
 * 实现步骤:
 * 1.设置列表项元素的类。开发者可以根据自身业务列表项的需求场景自行配置。
 * class ListInfo {
     icon: ResourceStr = '';
     name: ResourceStr = '';

     constructor(icon: ResourceStr = '', name: ResourceStr = '') {
       this.icon = icon;
       this.name = name;
     }
   }
 *
 * 2. 数据准备。首先构建一个ListInfo数组，然后向其中传入对应的内容数据。
 * @example
 * const MEMO_DATA: ListInfo[] = [
         new ListInfo($r("app.media.list_exchange_ic_public_cards_filled"), '账户余额'),
         new ListInfo($r("app.media.list_exchange_ic_public_cards_filled2"), 'xx银行储蓄卡（1234）'),
         new ListInfo($r("app.media.list_exchange_ic_public_cards_filled3"), 'xx银行储蓄卡（1238）'),
         new ListInfo($r("app.media.list_exchange_ic_public_cards_filled4"), 'xx银行储蓄卡（1236）')];
 * @State appInfoList: ListInfo[] = MEMO_DATA;
 *
 * 3. 声明管理列表项交换的类ListExchangeCtrl。通过ListExchangeCtrl来实现列表项与列表项之间的位置交换。具体实现请看后续的实现步骤章节。
 * 列表项交换类
 * @State listExchangeCtrl: ListExchangeCtrl<ListInfo> = new ListExchangeCtrl();

 * 4.自定义列表项组件。
 * listItemInfo: 列表项数据信息
 * @Builder deductionView(listItemInfo: ListInfo) {...}
 *
 * 5. 构建自定义列表视图。在代码合适的位置使用ListExchange组件并传入对应的参数。
 * @example
 * 列表交换视图
 * appInfoList: 数据源
 * listExchangeCtrl: 列表项交换类
 * deductionView: 列表项视图
 * ListExchange({
     appInfoList: this.appInfoList,
     listExchangeCtrl: this.listExchangeCtrl,
     deductionView: (listItemInfo: Object) => {
       this.deductionView(listItemInfo as Listinfo)
     }
   })
 */

@Component
export struct ListExchangeViewComponent {
  @State theme: SkinTheme.Theme = SkinTheme.getTheme();
  // 初始化列表数据
  // @State appInfoList: ListInfo[] = MEMO_DATA;
  @Link sheetList: Array<SheetEntity>;
  @Watch("updateSheetList") @Consume refreshListExchangeViewComponent: boolean;
  // 列表项元素交换类
  @State listExchangeCtrl: ListExchangeCtrl<SheetEntity> = new ListExchangeCtrl();

  private showDialog = new ShowDialog()

  async  updateSheetList() {
    await this.listExchangeCtrl.initData(this.sheetList);

    this.refreshListExchangeViewComponent = false;
  }

  // aboutToAppear(): void {
  //   this.listExchangeCtrl.initData(this.sheetList);
  // }

  build() {
    Column() {
      // 标题栏
      Row() {
        Text("扣款排序")
          .textAlign(TextAlign.Start)
        Blank()
        Text("自定义排序")
      }
      .backgroundColor(Color.White)
      .border({
        radius: {
          topLeft: 16,
          topRight: 16
        }
      })
      .padding({
        left: 12,
        right: 12
      })
      .width('100%')
      .height(50)

      /**
       * 列表交换视图
       * appInfoList: 数据源
       * listExchangeCtrl: 列表项交换类
       * deductionView: 列表项视图
       */
      ListExchange({
        appInfoList: this.sheetList,
        listExchangeCtrl: this.listExchangeCtrl,
        deductionView: (listItemInfo: Object, index: number) => {
          this.deductionView(listItemInfo as SheetEntity, index)
        }
      })
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor("#F3F3F3")
    .padding({ left: 12, right: 12 })
  }

  /**
   * ListItem自定义组件（开发者可以根据自己的需求设置列表项的UI）
   */
  @Builder
  deductionView(item: SheetEntity, index: number) {
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
            .onClick(e => {
              this.showDialog.openDialog(`确定要删除「${item.title}」吗？`, "温馨提示", false, async  () => {
                console.log("确认删除")
                await SheetDao.delete(item.sheetKey, item.title)

                emitter.emit(DialogConstants.SHOW_DIALOG_CONFIRM_EVENT_ID)
                this.showDialog.currentShowDialog()
              });

            })
        }
      }
      .width('82%')


    }
    .position({bottom: 0, right: 0})
    .width('100%')
    .justifyContent(FlexAlign.Start)
    // Row() {
    //   Image(listItemInfo.icon)
    //     .width(30)
    //     .height(30)
    //     .draggable(false) // TODO：知识点：保持默认值true时，图片有默认拖拽效果，会影响Grid子组件拖拽判断，所以修改为false
    //   Text(listItemInfo.name)
    //     .margin({ left: 16 })
    //   Blank()
    //   // 右边三条杠图标
    //   Image($r("app.media.list_exchange_ic_public_drawer"))
    //     .width(30)
    //     .height(30)
    //     .objectFit(ImageFit.Cover)
    //     .draggable(false) // TODO：知识点：保持默认值true时，图片有默认拖拽效果，会影响Grid子组件拖拽判断，所以修改为false
    // }
    // .width('100%')
    // .height(ITEM_HEIGHT)
    // .backgroundColor(Color.White)
    // .padding({
    //   left: 12,
    //   right: 12
    // })
  }
}