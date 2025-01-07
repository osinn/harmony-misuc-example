
@Entry
@Component
struct Index {
  @Provide('NavPathStack') pageStack: NavPathStack = new NavPathStack()

  @Builder
  PagesMap(name: string) {
    if (name === 'DialogPage') {
      DialogPage()
    }
  }

  build() {
    Navigation(this.pageStack) {
      Column() {
        Button('显示')
          .onClick(() => {
            this.pageStack.pushPathByName('DialogPage', '', false);
          })
      }
      .height('100%')
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .mode(NavigationMode.Stack)
    .navDestination(this.PagesMap)
  }
}

@Component
export struct DialogPage {
  @Consume('NavPathStack') pageStack: NavPathStack;
  listData: string[] = ['评论1', '评论2', '评论3', '评论4', '评论5', '评论6', '评论7', '评论8'];

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom }) {
        Column() {
          Text('评论1')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .onClick(e => {
              this.pageStack.clear()
            })

          List() {
            ForEach(this.listData, (item: string) => {
              ListItem() {
                Text(item)
                  .height(80)
                  .fontSize(20)
              }
            }, (item: string) => item)
          }
          .scrollBar(BarState.Off)
          .width('100%')
          .layoutWeight(1)

          TextInput({ placeholder: 'Please input content' })
            .height(40)
            .width('100%')
        }
        .backgroundColor(Color.White)
        .height('75%')
        .width('100%')
        .padding(12)
      }
      .height('100%')
      .width('100%')
    }
    .backgroundColor('rgba(0,0,0,0.2)')
    .hideTitleBar(true)
    .mode(NavDestinationMode.DIALOG)
  }
}