
@Component
export struct NavBar {

  @State searchKey: string = ''

  build() {
    Row() {
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
    }
  }
}