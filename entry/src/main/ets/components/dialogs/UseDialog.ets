import { promptAction } from '@kit.ArkUI'
import { GlobalContext } from '../../core/GlobalContext'
import { emitter } from '@kit.BasicServicesKit'

export class DialogConstants {
  /**
   * ShowDialog 确认关闭
   */
  static readonly SHOW_DIALOG_CONFIRM_EVENT_ID: string = 'showDialogOfConfirm';
  /**
   * ShowDialog 取消
   */
  static readonly SHOW_DIALOG_CANCEL_EVENT_ID: string = 'showDialogOfCancel';
}

@Builder
function customDialogBuilder(message: string, title: String, clickClose: boolean, confirm?: Function) {
  Column() {
    Row() {

      Text(`${title} `)
        .fontSize('20fp')
    }
    .padding('10vp')
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .height("50vp")

    Divider()
    Text(message)
      .fontSize('16fp')
      .height("20vp")
      .margin({ top: '10vp' })
    Row({ space: '30vp' }) {
      Button("取消").onClick(() => {
        emitter.emit(DialogConstants.SHOW_DIALOG_CANCEL_EVENT_ID)
        promptAction.closeCustomDialog(getCustomDialogId())
      })
        .fontColor('#000000')
        .backgroundColor('#FFFFFF')
        .width('130vp')
      Blank().width('0.2vp').height('20vp').backgroundColor('#000000')
      Button("确认").onClick(() => {
        if (confirm) {
          confirm()
        } else {
          emitter.emit(DialogConstants.SHOW_DIALOG_CONFIRM_EVENT_ID)
        }
        if (clickClose) {
          promptAction.closeCustomDialog(getCustomDialogId())
        }
      })
        .width('130vp')
    }
    .margin({ top: '20vp' })
  }
  .height('160vp')
  .padding('5vp')
}

function getCustomDialogId() {
  // 取customDialogId
  let customDialogId = GlobalContext.getContext().getObject('customDialogId') as number
  return customDialogId;
}


export class ShowDialog {
  constructor() {

  }

  /**
   * 打开对话弹窗
   * @param message     消息内容
   * @param title       标题
   * @param clickClose  点击确认按钮是否自动关闭，默认是自动关闭
   * @param confirm     点击确认按钮回调方法，有回调方法则不会发送点击确认按钮通知事件
   */
  openDialog(message: string, title: string = '温馨提示', clickClose: boolean = true, confirm?: Function) {
    const that = GlobalContext.getContext().getObject('UIContext') as UIContext;
    if (that) {
      promptAction.openCustomDialog({
        builder: customDialogBuilder.bind(that, message, title, clickClose, confirm),
        backgroundColor: '#FFFFFF'
      })
        .then((dialogId: number) => {
          GlobalContext.getContext().setObject('customDialogId', dialogId)
        })
    }
  }

  currentShowDialog() {
    promptAction.closeCustomDialog(getCustomDialogId())
  }
}