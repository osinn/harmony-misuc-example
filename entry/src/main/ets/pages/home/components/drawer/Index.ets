import { curves } from '@kit.ArkUI';

import { DrawerList } from './DrawerList'

interface Data {
  color: Color
  txt: string
}

@Component
export struct NavBar {
  // 侧边栏数据源
  @State datas: Data[] = []
  // 点击item
  @State ckitem: number = 0
  // 侧边栏显示控制器
  @State isShowing: boolean = false
  // 手指按下x坐标
  private downx: number = 0
  // 手指移动x坐标
  private movex: number = 0

  aboutToAppear(): void {
    this.datas = [//数据源
      {
        txt: '白色',
        color: Color.White
      },
      {
        txt: '黑色',
        color: Color.Black
      },
      {
        txt: '红色',
        color: Color.Red
      },
      {
        txt: '绿色',
        color: Color.Green
      },
      {
        txt: '蓝色',
        color: Color.Blue
      },
    ]
  }

  build() {
    SideBarContainer(SideBarContainerType.Overlay) {
      Column() { //侧边栏内容区默认宽度240vp
        DrawerList();
      }.width('100%')
      .height('100%')
      .backgroundColor(Color.Gray)
      .borderRadius(10)

      Column() { //内容区
        Text(this.datas[this.ckitem].txt).fontSize(30).fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.datas[this.ckitem].color)
      .justifyContent(FlexAlign.Center)
      .onTouch((event) => { //监听手指右边滑动和点击事件
        if (event.type == TouchType.Move) {
          this.movex = event.touches[0].x
          if ((this.movex - this.downx) > 50) { //产生了右侧滑动 打开抽屉
            animateTo({ curve: curves.springMotion() }, () => {
              this.isShowing = true
            })
          }
        } else if (event.type == TouchType.Down) {
          this.downx = event.touches[0].x
          // 点击内容区就会关闭抽屉
          animateTo({ curve: curves.springMotion() }, () => {
            this.isShowing = false
          })
        }
      })
    }
    .height('100%')
    .width('100%')
    .showSideBar($$this.isShowing) //双向绑定 控制抽屉的开和关
  }
}

