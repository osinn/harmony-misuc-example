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
import { SkinTheme } from '../../core/Theme'
import { GlobalContext } from '../../core/GlobalContext'
const TAG = 'foo'
@Entry
@Component
struct Index {
  @State message: string = '主页'
  @State isVertical: boolean = false;// 是否纵屏状态
  @State isShowSideBar: boolean = false;
  @State theme: SkinTheme.Theme = SkinTheme.getTheme();
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
    GlobalContext.getContext().setObject('UIContext', this)

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
        SideBarContainer(SideBarContainerType.Overlay){
          Column(){
            Text('侧边栏内容')
            Button('关闭')
              .onClick(()=>{
                animateTo({duration: 550},()=>{this.isShowSideBar = false}) //动画关闭侧边栏
              })
          }
          .height('100%')
          .width('60%')
          .backgroundColor(Color.Pink)
          Column(){
            // 顶部搜索
            NavBar({ openDrawer: () => {
              animateTo({duration: 550},()=>{this.isShowSideBar = true})
            }})
            if (this.isVertical) {
              HomeBody()
            } else {
              HomeBodyHorizontal();
            }
          }
          .width('100%')
          .height('100%')
          .onTouch((event) => { //监听手指右边滑动和点击事件
            if (event.type == TouchType.Down && this.isShowSideBar) {
              animateTo({duration: 550}, () => {this.isShowSideBar = false})
            }
          })
        }
        .showSideBar($$this.isShowSideBar) //不显示侧边栏
        .showControlButton(false) //不显示控制按钮
        .sideBarWidth('80%')  //侧边栏宽度
        .maxSideBarWidth('100%')//最大宽度
      }
    }
    .height('100%')
  }
}