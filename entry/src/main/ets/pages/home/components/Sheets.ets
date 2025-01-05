@Component
export struct Sheets {
  @State currentIndex: number = 0;

  @Builder
  tabBuilder(index: number, name: string, musicNumb: number = 0) {
    Row() {
      Column() {
        Text(name)
          // .fontColor('#FFFFFF')
          .margin({ bottom: 5 })
          .onClick(() => {
            this.currentIndex = index;
          })
        Divider()
          .width('100%')
          .strokeWidth(2)
          .color('#0A59F7')
          .opacity(this.currentIndex === index ? 1 : 0)
      }
      .width('70vp')
      .height('30vp')

      Column() {
        Text(`(${musicNumb})`)// .lineHeight(7)
          .fontSize(12)
          // .fontColor('#FFFFFF')
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
              this.tabBuilder(0, '我的歌单', 10)

              this.tabBuilder(1, '收藏歌单')
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
              Image($r("app.media.ic_plus"))
                .width('20vp')
                .height('18vp')
                // .fillColor('#FFFFFF')
                .margin({ right: '10vp' })
                .onClick(e => {
                  console.log("点击搜索：");
                })
              Image($r("app.media.ic_inbox_arrow_down"))
                .width('20vp')
                .height('18vp')
                .margin({ right: '10vp' })
                .onClick(e => {
                  console.log("点击搜索：");
                })
            }

            .height('30vp')
          }
          // .flexBasis(200)
          .width(100)
          .height('100%')
          // .backgroundColor("#000000")
          .alignItems(HorizontalAlign.End)
          .justifyContent(FlexAlign.End)
        }
        // .backgroundColor("#E6A23C")
        .width('100%')
        .height('30vp')

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Column() {
            Text('歌单列表')
          }
          .height('100%')
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
        }
        .height('100%')
        .width('100%')
        .backgroundColor("#67C23A")
      }
      .width('100%')
      .height('100%')
    }
  }
}