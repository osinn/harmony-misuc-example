
import { SkinTheme } from '../../../../core/Theme'
import { mediaIcon } from '../../../../core/Icon'

interface ActionButton {
  /**
   * What is this character
   */
  iconName: string;

  /**
   * This character is relative to the start time of the line. Unit: ms.
   */
  title: string;

  /**
   * The duration of this character. Unit: ms.
   */
  action: () => void;
}

@Component
export struct Operations {
  @State theme: SkinTheme.Theme = SkinTheme.getTheme();

  @State actionButtons: ActionButton[] = [
    {
      iconName: 'ic_octicon_thumbsup',
      title: '推荐歌单',
      action() {
        console.log("点击推荐歌单")
      }

    },
    {
      iconName: 'ic_trophy',
      title: '榜单',
      action() {
        console.log("点击榜单")
      }
    },
    {
      iconName: 'ic_clock',
      title: '播放记录',
      action() {
      }
    },
    {
      iconName: 'ic_folder_music_outline',
      title: '本地音乐',
      action() {
      }
    },
    {
      iconName: 'ic_aliyunpan',
      title: '阿里云盘',
      action() {
      }
    }
  ]

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
              item.action()
            })
          Text(item.title)
            .fontSize('14fp')
            .fontColor(this.theme.fontColor)
            .onClick(e => {
              item.action()
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
    .height('70vp')
    .width((this.actionButtons.length * 82 + this.actionButtons.length * 10) + 'vp')
    .justifyContent(FlexAlign.SpaceBetween)
  }
}