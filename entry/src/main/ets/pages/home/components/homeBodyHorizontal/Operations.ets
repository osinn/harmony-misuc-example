import { SkinTheme } from '../../../../core/Theme'
import { mediaIcon } from '../../../../core/Icon'
import { ActionButtonItem, ActionButton } from '../homeBody/ActionButtons'

@Component
export struct Operations {

  @State theme: SkinTheme.Theme = SkinTheme.getTheme();
  @StorageLink('pageIndexInfos') pageIndexInfos: NavPathStack = new NavPathStack();

  private actionButtons= ActionButtonItem

  build() {
    Column({ space: 4 }) {
      ForEach(this.actionButtons, (item: ActionButton, index: number) => {
        Column({ space: 4 }) {
          Image(mediaIcon(item.iconName))
            .width('20vp')
            .height('18vp')
            .syncLoad(true)
            .fillColor(this.theme.iconColor)
            .onClick(e => {
              item.action(this.pageIndexInfos)
            })
          Text(item.title)
            .fontSize('14fp')
            .fontColor(this.theme.fontColor)
            .onClick(e => {
              item.action(this.pageIndexInfos)
            })
          // Text(item.title)
          //   .backgroundColor(0xFFFFFF)
          //   .borderRadius(12)
          //   .fontSize(14)
          //   .textAlign(TextAlign.Center)
          //   .width('82vp')
          //   .height('65vp')
          //   .margin({
          //     top: index == 0 ? '0vp':'10vp'//index % 4 ? '10vp' : (index == this.actionButtons.length - 1 && this.actionButtons.length % 2 != 0) ? '10vp' : '0vp'
          //   })

        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(this.theme.gridBackgroundColor)
        .width('82vp')
        .height('65vp')
        .borderRadius(12)

      }, (item: ActionButton, index?: number) => {
        return index + JSON.stringify(item);
      })
    }
    .height((this.actionButtons.length * 65 + this.actionButtons.length * 10 + (this.actionButtons.length * 4)) + 'vp')
  }
}