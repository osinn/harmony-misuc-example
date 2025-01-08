import { promptAction } from '@kit.ArkUI'
import { GlobalContext } from '../../core/GlobalContext'

@Builder
export function customDialogBuilder(content: String) {
  Column() {
    Text(`Tip: ${content} `).fontSize(20).height("30%")
    Text('失败原因：失败原因失败原因失败原因失败原因失败原因失败原因失败原因!').fontSize(16).height("30%")
    Row() {
      Button("确认").onClick(() => {
        console.log("确认")
        promptAction.closeCustomDialog(getCustomDialogId())
      })
      Blank().width(50)
      Button("取消").onClick(() => {
        console.log("取消")
        promptAction.closeCustomDialog(getCustomDialogId())
      })
    }
    .margin({ top: 30 })
  }.height(200).padding(5)
}

function getCustomDialogId() {
  // 取customDialogId
  let customDialogId = GlobalContext.getContext().getObject('customDialogId') as number
  return customDialogId;
}

export function showDialog() {
  const that = GlobalContext.getContext().getObject('UIContext') as UIContext;
  if (that) {
    promptAction.openCustomDialog({
      builder: customDialogBuilder.bind(that, "网络请求失败！")
    }).then((dialogId: number) => {
      GlobalContext.getContext().setObject('customDialogId', dialogId)
    })
  }
}