import { router } from '@kit.ArkUI';

// import Drawer from './drawer/Index'
import { SkinTheme } from '../../../core/Theme'

@Component
export struct NavBar {

  @State searchKey: string = ''
  @State theme: SkinTheme.Theme = SkinTheme.getTheme();

  openDrawer=()=>{

  }

  build() {
    Row() {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
        // Drawer({isShow: this.isShowDrawer})

        Image($r("app.media.ic_list_bullet"))
          .width('20vp')
          .height('18vp')
          .fillColor(this.theme.iconColor)
          .onClick(e => {
            // router.pushUrl({ url: 'pages/Second', params: { "name": "测试传参数" } })
            this.openDrawer()
          })
        Search({
          placeholder: '点击这里开始搜索'
        })
          .backgroundColor(this.theme.searchBackgroundColor)
          .placeholderColor(this.theme.placeholderColor)
          .fontColor(this.theme.fontColor)
          .onChange(e => {
            console.log("输入内容：" + e);
            this.searchKey = e;
          })
          .margin({ left: '10vp' })
          .height('30vp')
      }
      .padding('10vp')
      .margin({bottom: '5vp'})
      .height('30vp')
    }
  }
}