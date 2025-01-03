// Index.ets
import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { Environment } from '@kit.CoreFileKit';
import { fileIo as fs } from '@kit.CoreFileKit';

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


@Entry
@Component
struct Index {
  @State message: string = '主页'
  @State searchKey: string = ''
  @State ActionButtonOptionWidth: number = 0;

  scroller: Scroller = new Scroller()
  @State actionButtons: ActionButton[] = [
    {
      iconName: 'fire',
      title: '菜单1',
      action() {
      }

    },
    {
      iconName: 'trophy',
      title: '菜单2',
      action() {
      }
    },
    {
      iconName: 'clock-outline',
      title: '菜单2',
      action() {
      }
    },
    {
      iconName: 'folder-music-outline',
      title: '菜单4',
      action() {
      }
    },
    {
      iconName: 'aliyunpan',
      title: '菜单5',
      action() {
      }
    },
    {
      iconName: 'aliyunpan',
      title: '菜单6',
      action() {
      }
    }
  ]

  @Builder
  ActionButtonOptions() {
    Row() {
      ForEach(this.actionButtons, (item: ActionButton) => {
        Column({ space: 4 }) {
          Button() {
            Text(item.title)
              .backgroundColor(0xFFFFFF)
              .borderRadius(12)
              .fontSize(14)
              .textAlign(TextAlign.Center)
              .width('70vp')
              .height('65vp')
          }
        }

      }, (item: ActionButton, index?: number) => {
        return index + JSON.stringify(item);
      })
    }
    .height('70vp')
    .width((this.actionButtons.length * 70) + 'vp')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    Row() {
      Column() {
        // 顶部搜索
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Image($r("app.media.ic_list_bullet"))
            .width('20vp')
            .height('18vp')
            .onClick(e => {
              console.log("点击搜索：" + this.searchKey);
            })
          Search({
            placeholder: '点击这里开始搜索'
          })
            .onChange(e => {
              console.log("输入内容：" + e);
              this.searchKey = e;
            })
            .margin({ left: '10vp' })
            .height('30vp')
        }
        .padding('10vp')
        .height('30vp')

        // 推荐歌单、榜单等等
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Scroll(this.scroller) {
            this.ActionButtonOptions()
          }
          .scrollable(ScrollDirection.Horizontal) // 滚动方向横向
          .scrollBar(BarState.On) // 滚动条常驻显示
          .scrollBarColor(Color.Gray) // 滚动条颜色
          .scrollBarWidth(10) // 滚动条宽度
          .friction(0.6)
          .edgeEffect(EdgeEffect.None)
          .onWillScroll((xOffset: number, yOffset: number, scrollState: ScrollState) => {
            console.info(xOffset + ' ' + yOffset)
          })
          .onScrollEdge((side: Edge) => {
            console.info('To the edge')
          })
          .onScrollStop(() => {
            console.info('Scroll Stop')
          })
        }
        .width('100%')
        // .padding('10vp')
        .height('70vp')
        .backgroundColor("#1a182431")

        // 我的歌单列表
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Image($r("app.media.ic_list_bullet"))
            .width('20vp')
            .height('18vp')
            .onClick(e => {
              console.log("点击搜索：" + this.searchKey);
            })
          Search({
            placeholder: '点击这里开始搜索hahah'
          })
            .onChange(e => {
              console.log("输入内容：" + e);
              this.searchKey = e;
            })
            .margin({ left: '10vp' })
        }
        .padding('10vp')
        .height('100%')
        .backgroundColor("#F56C6C")

      }
    }
    .height('100%')
  }
}