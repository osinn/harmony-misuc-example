// Index.ets
import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { Environment } from '@kit.CoreFileKit';
import { fileIo as fs } from '@kit.CoreFileKit';

import { NavBar } from './components/NavBar'
import { HomeBody } from './components/homeBody/Index'
import { display, window } from '@kit.ArkUI';


@Entry
@Component
struct Index {
  @State message: string = '主页'
  @State isLandscape: boolean = false;// 是否横屏状态
  // @Watch('setWindowLayOut')
  //
  //
  // setWindowLayOut() {
  //   // 调用该接口手动改变设备横竖屏状态（设置全屏模式，先强制横屏，再加上传感器模式）
  //   window.getLastWindow(getContext(this)).then((windowClass) => {
  //     if (this.isLandscape) {
  //       console.log('设置屏幕横屏')
  //       windowClass.setPreferredOrientation(window.Orientation.AUTO_ROTATION_LANDSCAPE);
  //     } else {
  //       console.log('设置屏幕竖屏')
  //       windowClass.setPreferredOrientation(window.Orientation.AUTO_ROTATION_PORTRAIT);
  //     }
  //   });
  // }


  build() {
    Row() {
      Column() {
        // 顶部搜索
        NavBar()
        HomeBody()
        // 推荐歌单、榜单等等


        // 我的歌单列表
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Image($r("app.media.ic_list_bullet"))
            .width('20vp')
            .height('18vp')
            .onClick(e => {
              console.log("点击搜索：");
            })
          Search({
            placeholder: '点击这里开始搜索hahah'
          })
            .onChange(e => {
              console.log("输入内容：" + e);
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