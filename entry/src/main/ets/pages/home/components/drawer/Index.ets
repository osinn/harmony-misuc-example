import { curves } from '@kit.ArkUI';

interface Data {
  color: Color
  txt: string
}

@Component
export  struct NavBar {
  // 侧边栏数据源
  @State datas: Data[] = []
  // 点击item
  @State ckitem: number = 0
  // 侧边栏显示控制器
  @State isshowing: boolean = false
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
        ForEach(this.datas, (item: Data, index: number) => {
          ListItem() {
            Text(item.txt)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Center)
              .border({ width: 2, style: BorderStyle.Dotted })
              .width('100%')
              .padding(20)
              .onClick(() => { //点击列表项
                this.ckitem = index //更新点击下标 进而重新渲染内容区背景颜色
                animateTo({curve:curves.springMotion()},()=>{this.isshowing = false}) //动画关闭侧边栏
              })
          }
        }, (item: Data) => JSON.stringify(item))
      }.width('100%')
      .height('100%')
      .backgroundColor(Color.Gray)
      .borderRadius(10)

      Column() { //内容区
        Text(this.datas[this.ckitem].txt).fontSize(30).fontWeight(FontWeight.Bold)
      }.width('100%')
      .height('100%')
      .backgroundColor(this.datas[this.ckitem].color)
      .justifyContent(FlexAlign.Center)
      .onTouch((event) => { //监听手指右边滑动和点击事件
        if (event.type == TouchType.Move) {
          this.movex = event.touches[0].x
          if ((this.movex - this.downx) > 50) { //产生了右侧滑动 打开抽屉
            animateTo({curve:curves.springMotion()},()=>{this.isshowing = true})
          }
        } else if (event.type == TouchType.Down) {
          this.downx = event.touches[0].x
          // 点击内容区就会关闭抽屉
          animateTo({curve:curves.springMotion()},()=>{this.isshowing = false})
        }
      })
    }
    .height('100%')
    .width('100%')
    .showSideBar($$this.isshowing) //双向绑定 控制抽屉的开和关
  }
}

