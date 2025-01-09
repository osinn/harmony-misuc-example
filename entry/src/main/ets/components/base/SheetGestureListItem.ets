// import { util } from '@kit.ArkTS'
// import { SheetEntity } from '../../db/SheetEntity'
// import { SkinTheme } from '../../core/Theme'
// import SheetDao from '../../db/SheetDao'
// import { ArrayList } from '@kit.ArkTS'; //用于存储和管理歌单目录列表
//
// import { ShowDialog, DialogConstants } from '../../components/dialogs/UseDialog'
// import { emitter } from '@kit.BasicServicesKit';
//
// /**
//  * 手势列表-可拖拽排序
//  */
// @Component
// export default struct SheetGestureListItem {
//   // 歌单key
//   @Consume musicSheetKey: string;
//   @State theme: SkinTheme.Theme = SkinTheme.getTheme();
//
//   @Consume sheetList: Array<SheetEntity>;
//
//   private showDialog = new ShowDialog()
//
//   @State currentListItem?:SheetEntity = undefined
//
//   @Builder
//   deductionView(item: SheetEntity, index: number) {
//     Row() {
//       if (index == 0) {
//         Image($r("app.media.album_default"))
//           .width('40vp')
//           .height('40vp')
//           .margin('10vp')
//           .borderRadius(8)
//
//         Image($r("app.media.ic_heart"))
//           .width('20vp')
//           .height('20vp')
//           .margin('10vp')
//           .borderRadius(8)
//           .fillColor('red')
//           .position({top: '10vp', left: '10vp'})
//
//       } else {
//         Image($r("app.media.album_default"))
//           .width('40vp')
//           .height('40vp')
//           .margin('10vp')
//           .borderRadius(8)
//       }
//
//       Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
//         Column({ space: 5 }) {
//           Text(item.title)
//             .fontColor(this.theme.fontColor)
//             .fontSize('14fp')
//           Text(`${item.numb ? item.numb : 0}首`)
//             .fontColor(this.theme.subtitleTextColor)
//             .fontSize('10fp')
//         }
//         .width('100%')
//         .alignItems(HorizontalAlign.Start)
//
//         if (index != 0) {
//           Image($r("app.media.ic_trash_outline"))
//             .width('18vp')
//             .height('18vp')
//             .margin('10vp')
//             .onClick(e => {
//               this.showDialog.openDialog(`确定要删除「${item.title}」吗？`, "温馨提示", false, async  () => {
//                 console.log("确认删除")
//                 await SheetDao.delete(item.sheetKey, item.title)
//
//                 emitter.emit(DialogConstants.SHOW_DIALOG_CONFIRM_EVENT_ID)
//                 this.showDialog.currentShowDialog()
//               });
//               // this.getUIContext().showAlertDialog(
//               //   {
//               //     title: '温馨提示',
//               //     message: `确定要删除「${item.title}」吗？`,
//               //     buttons: [{
//               //       value: '取消',
//               //       action: () => {
//               //         console.info('Callback when the first button is clicked')
//               //       }
//               //     },
//               //       {
//               //         enabled: true,
//               //         defaultFocus: true,
//               //         style: DialogButtonStyle.HIGHLIGHT,
//               //         value: '确定',
//               //         action: () => {
//               //           console.info('Callback when the second button is clicked')
//               //         }
//               //       }],
//               //   }
//               // )
//               // emitter.emit('musicSheetPanelDeleteItem', {
//               //   data: {
//               //     deleteItem: item,
//               //     sheetKey: this.musicSheetKey,
//               //   }
//               // })
//             })
//         }
//       }
//       .width('82%')
//
//
//     }
//     .position({bottom: 0, right: 0})
//     .width('100%')
//     .justifyContent(FlexAlign.Start)
//   }
//
//   build() {
//     List() {
//       ForEach(this.sheetList, (item: SheetEntity, index: number) => {
//         ListItem() {
//           this.deductionView(item, index)
//         }
//         .zIndex(this.currentListItem === item ? 2 : 1) // 层级属性
//         .transition(TransitionEffect.OPACITY)
//         .attributeModifier(this.listExchangeCtrl.getModifier(item)) //动态设置组件的属性方法， 参数为属性修改器
//
//       }, (item: SheetEntity) => JSON.stringify(item))
//     }
//     .divider({ strokeWidth: 2 })
//     .width('100%')
//   }
// }