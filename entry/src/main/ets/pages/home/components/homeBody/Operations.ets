

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

  @State actionButtons: ActionButton[] = [
    {
      iconName: 'fire',
      title: '推荐歌单',
      action() {
      }

    },
    {
      iconName: 'trophy',
      title: '榜单',
      action() {
      }
    },
    {
      iconName: 'clock-outline',
      title: '播放记录',
      action() {
      }
    },
    {
      iconName: 'folder-music-outline',
      title: '本地音乐',
      action() {
      }
    },
    {
      iconName: 'folder-music-outline',
      title: '阿里云盘',
      action() {
      }
    }
  ]

  build() {
    Row() {
      ForEach(this.actionButtons, (item: ActionButton, index: number) => {
        Column({ space: 4 }) {
          Text(item.title)
            .backgroundColor(0xFFFFFF)
            .borderRadius(12)
            .fontSize(14)
            .textAlign(TextAlign.Center)
            .width('82vp')
            .height('65vp')
            .margin({
              left: index == 0 ? '0vp':'10vp'//index % 4 ? '10vp' : (index == this.actionButtons.length - 1 && this.actionButtons.length % 2 != 0) ? '10vp' : '0vp'
            })

        }

      }, (item: ActionButton, index?: number) => {
        return index + JSON.stringify(item);
      })
    }
    .height('70vp')
    .width((this.actionButtons.length * 82 + this.actionButtons.length * 10) + 'vp')
    .justifyContent(FlexAlign.SpaceBetween)
  }
}