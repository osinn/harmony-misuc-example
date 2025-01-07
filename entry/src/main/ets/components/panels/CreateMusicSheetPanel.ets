// 创建歌单面板

import { display } from '@kit.ArkUI';
import { SkinTheme } from '../../core/Theme'
import Toast from '../../core/Toast'
import SheetDao from '../../db/SheetDao'
import { JSON } from '@kit.ArkTS';

@Component
export default struct CreateMusicSheetPanel {
  private sheetTableDao = SheetDao
  @State theme: SkinTheme.Theme = SkinTheme.getTheme();
  // 是否显示半屏模态页面
  @Link isPresent: boolean;
  // 歌单key
  @Consume musicSheetKey: string;
  // 半模态高度
  @State sheetHeight: number = 300;
  // 是否显示控制条
  @State showDragBar: boolean = true;
  // 是否显示在中间
  @State isCenter: boolean = true;
  @State screenW: number = px2vp(display.getDefaultDisplaySync().width);
  private deviceSize: number = 400; // 依据Navigation的mode属性说明，如使用Auto，窗口宽度>=600vp时，采用Split模式显示；窗口宽度<600vp时，采用Stack模式显示。
  // 当前屏幕折叠态（仅折叠屏设备下有效）
  curFoldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
  @State musicSheetValue: string = '';

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
  halfModalCreateMusicSheetPanel() {
    Column() {
      Row() {
        Text('取消')
          .fontSize('13fp')
          .fontWeight('2fp')
          .fontColor(this.theme.cancelButtFontColor)
          .onClick(async () => {
            const musicSheetList = await this.sheetTableDao.querySheetAll();
            console.log("歌单" + JSON.stringify(musicSheetList))
            this.isPresent = false
          })

        Text('创建歌单')
          .fontSize('16fp')
          .fontWeight('5fp')

        Text('确定')
          .fontSize('13fp')
          .fontWeight('2fp')
          .fontColor(this.theme.confirmButtFontColor)
          .onClick(async () => {
            if (this.musicSheetKey) {

              const musicSheet = await this.sheetTableDao.querySheetByKey(this.musicSheetKey)
              if (musicSheet == null || this.musicSheetValue != musicSheet.title) {
                console.log("添加歌单" +  this.musicSheetValue + " ==== " +musicSheet?.title)
                await this.sheetTableDao.insert(this.musicSheetKey, this.musicSheetValue);
                this.isPresent = false
              } else {
                Toast.warn(`已存在${this.musicSheetValue}`);
              }
            } else {
              Toast.warn("请选择创建歌单类型");
              // promptAction.showToast({message: "请选择创建歌单类型"})
            }
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: '20vp', right: '20vp' })
      .height(50)
      .width('100%')

      TextInput({ text: $$this.musicSheetValue, placeholder: '新建歌单' })
        .placeholderColor(this.theme.placeholderColor)
    }
  }

  build() {
    Column() {
      // TODO：需求：增加其他登录方式，如全模态窗口
      Text()/**
       * TODO: 知识点: 通过bindSheet属性为组件绑定半模态页面，由于半模态必须绑定组件，
       * 此处绑定无样式的Text组件作为开屏半模态展示。
       * isPresent：是否显示半模态页面
       */
        .bindSheet($$this.isPresent, this.halfModalCreateMusicSheetPanel(), {
          // Text绑定半模态转场
          height: this.sheetHeight, // 半模态高度
          dragBar: this.showDragBar, // 是否显示控制条
          // 平板或折叠屏展开态在中间显示
          preferType: this.isCenter ? SheetType.CENTER : SheetType.POPUP,
          backgroundColor: '#FEFEFE',
          showClose: false, // 是否显示关闭图标
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