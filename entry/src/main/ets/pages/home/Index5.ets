

import { display } from '@kit.ArkUI';
import promptAction from '@ohos.promptAction';


@Entry
@Component
export struct Index {
  // 是否显示半屏模态页面
  @State isPresent: boolean = true;
  // 半模态高度
  @State sheetHeight: number = 500;
  // 是否显示控制条
  @State showDragBar: boolean = true;
  // 是否显示在中间
  @State isCenter: boolean = true;
  @State screenW: number = px2vp(display.getDefaultDisplaySync().width);
  private deviceSize: number = 600; // 依据Navigation的mode属性说明，如使用Auto，窗口宽度>=600vp时，采用Split模式显示；窗口宽度<600vp时，采用Stack模式显示。
  // 当前屏幕折叠态（仅折叠屏设备下有效）
  curFoldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;

  aboutToAppear(): void {
    if (display.isFoldable()) {
      this.regDisplayListener();
    } else {
      if (this.screenW >= this.deviceSize) {
        this.isCenter = true;
      } else {
        this.isCenter = false;
      }
    }
  }

  /**
   * 注册屏幕状态监听
   * @returns {void}
   */
  regDisplayListener(): void {
    this.changePreferType(display.getFoldStatus());
    display.on('foldStatusChange', async (curFoldStatus: display.FoldStatus) => {
      // 同一个状态重复触发不做处理
      if (this.curFoldStatus === curFoldStatus) {
        return;
      }
      // 缓存当前折叠状态
      this.curFoldStatus = curFoldStatus;
      this.changePreferType(this.curFoldStatus);
    })
  }

  // 更改PreferType
  changePreferType(status: number): void {
    if (status === display.FoldStatus.FOLD_STATUS_FOLDED) {
      this.isCenter = false;
    } else {
      this.isCenter = true;
    }
  }

  // 半模态窗口页面内容区域
  @Builder
  halfModalLogin() {
    Column() {

    }
  }

  build() {
    Column() {
      // TODO：需求：增加其他登录方式，如全模态窗口
      Text('dd')/**
       * TODO: 知识点: 通过bindSheet属性为组件绑定半模态页面，由于半模态必须绑定组件，
       * 此处绑定无样式的Text组件作为开屏半模态展示。
       * isPresent：是否显示半模态页面
       */
        .bindSheet($$this.isPresent, this.halfModalLogin(), {
          // Text绑定半模态转场
          height: this.sheetHeight, // 半模态高度
          dragBar: this.showDragBar, // 是否显示控制条
          // 平板或折叠屏展开态在中间显示
          preferType: this.isCenter ? SheetType.CENTER : SheetType.POPUP,
          backgroundColor: '#FEFEFE',
          showClose: true, // 是否显示关闭图标
          shouldDismiss: ((sheetDismiss: SheetDismiss) => { // 半模态页面交互式关闭回调函数
            sheetDismiss.dismiss();

          })
        })
    }
    .justifyContent(FlexAlign.Center)
    .size({
      width: $r('app.string.multimodaltransion_size_full'),
      height: $r('app.string.multimodaltransion_size_full')
    })
    .padding($r('app.integer.multimodaltransion_padding_default'))
  }
}