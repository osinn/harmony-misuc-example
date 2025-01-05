import { router } from '@kit.ArkUI';

@Component
export struct NavBar {

  @State searchKey: string = ''
  @State isShowDrawer: boolean =  false;
  build() {
    Row() {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
        Image($r("app.media.ic_list_bullet"))
          .width('20vp')
          .height('18vp')
          .onClick(e => {
            // router.pushUrl({ url: 'pages/Second', params: { "name": "测试传参数" } })
            console.log("点击搜索：" + this.searchKey);
            this.isShowDrawer = true;
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