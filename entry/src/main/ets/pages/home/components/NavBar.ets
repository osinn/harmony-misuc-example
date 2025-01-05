import { router } from '@kit.ArkUI';

// import Drawer from './drawer/Index'
import { SkinTheme } from '../../../skin/Theme'

@Component
export struct NavBar {

  @State searchKey: string = ''
  @State theme: SkinTheme.Theme = SkinTheme.getTheme(1);

  openDrawer=()=>{

  }

  build() {
    Row() {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
        // Drawer({isShow: this.isShowDrawer})

        Image($r("app.media.ic_list_bullet"))
          .width('20vp')
          .height('18vp')
          .fillColor(this.theme.text_color)
          .onClick(e => {
            // router.pushUrl({ url: 'pages/Second', params: { "name": "测试传参数" } })
            this.openDrawer()
          })
        Search({
          placeholder: '点击这里开始搜索'
        })
          .backgroundColor(this.theme.page_background)
          .placeholderColor(this.theme.placeholder)
          .fontColor(this.theme.text_color)
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