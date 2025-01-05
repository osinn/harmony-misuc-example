// Index.ets
import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { Environment } from '@kit.CoreFileKit';
import { fileIo as fs } from '@kit.CoreFileKit';

import { NavBar } from './components/NavBar'
import { HomeBody } from './components/homeBody/Index'
import { HomeBodyHorizontal } from './components/homeBodyHorizontal/Index'
import { display, window } from '@kit.ArkUI';

const TAG = 'foo'
@Entry
@Component
struct Index {
  @State message: string = '主页'
  @State isVertical: boolean = false;// 是否纵屏状态

  async  aboutToAppear() {

    // 获取状态栏高度
    // window.getLastWindow(getContext(this)).then((data: window.Window) => {
    //   // 状态栏高度
    //   this.model.statusBarHeight = DrawerLayout.Utils.toVp(data.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
    //     .topRect
    //     .height);
    //   // 初始化数据
    //   this.initData();
    //   // 绑定回调函数 绑定当前应用实例
    //   this.mediaqueryListener.on('change', this.onPortrait.bind(this));
    //   // 监听切换左右侧边栏
    //   this.model.drawerTypeChangeCallback = (dt: DrawerLayout.Type) => {
    //     this.currentDrawerType = dt;
    //   }
    // })

    let d = await display.getDefaultDisplaySync()
    this.isVertical = d.rotation == 0 || d.rotation == 2;

    this.setOrientation()

    let callback = async () => {
      let d = await display.getDefaultDisplaySync()
      this.isVertical = d.rotation == 0 || d.rotation == 2;
      console.log("屏幕方向", this.isVertical)
    }
    try {
      display.on("change", callback); // 监听屏幕状态改变
    } catch (exception) {
      console.error(TAG, 'Failed to register callback. Code: ' + JSON.stringify(exception));
    }
  }

  setOrientation() {
    try {
      window.getLastWindow(getContext(this), (err, data) => { // 获取window实例
        if (err.code) {
          console.error(TAG, 'Failed to obtain the top window. Cause: ' + JSON.stringify(err));
          return;
        }
        let windowClass = data;
        console.info(TAG, 'Succeeded in obtaining the top window. Data: ' + JSON.stringify(data));

        let orientation = window.Orientation.AUTO_ROTATION; // 设置窗口方向为传感器自动旋转模式。
        try {
          windowClass.setPreferredOrientation(orientation, (err) => {
            if (err.code) {
              console.error(TAG, 'Failed to set window orientation. Cause: ' + JSON.stringify(err));
              return;
            }
            console.info(TAG, 'Succeeded in setting window orientation.');
          });
        } catch (exception) {
          console.error(TAG, 'Failed to set window orientation. Cause: ' + JSON.stringify(exception));
        }
        ;
      });
    } catch (exception) {
      console.error(TAG, 'Failed to obtain the top window. Cause: ' + JSON.stringify(exception));
    }
    ;
  }

  build() {
    Row() {
      Column() {
        // 顶部搜索
        NavBar()
        if (this.isVertical) {
          HomeBody()
        } else {
          HomeBodyHorizontal();
        }
      }
    }
    .height('100%')
  }
}