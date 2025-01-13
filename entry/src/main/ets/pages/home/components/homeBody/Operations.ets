
import { SkinTheme } from '../../../../core/Theme'
import { mediaIcon } from '../../../../core/Icon'
import { ActionButtonItem, ActionButton } from './ActionButtons'


@Component
export struct Operations {
  @State theme: SkinTheme.Theme = SkinTheme.getTheme();

  private actionButtons= ActionButtonItem

  @StorageLink('pageIndexInfos') pageIndexInfos: NavPathStack = new NavPathStack();

  build() {
    Row() {
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
            // .margin({
            //   left: index == 0 ? '0vp':'10vp'//index % 4 ? '10vp' : (index == this.actionButtons.length - 1 && this.actionButtons.length % 2 != 0) ? '10vp' : '0vp'
            // })
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
    .width((this.actionButtons.length * 82 + this.actionButtons.length * 10) + 'vp')
    .justifyContent(FlexAlign.SpaceBetween)
  }
}