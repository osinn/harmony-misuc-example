
import {Operations} from './Operations'

import {Sheets} from '../Sheets'

@Component
export  struct HomeBodyHorizontal {

  scroller: Scroller = new Scroller()
  build() {
    Stack({ alignContent: Alignment.Start }) {
      Scroll(this.scroller) {
        Operations()
      }
      .width('100vp')
      .height('100%')
      .scrollable(ScrollDirection.Vertical) //横向
      .scrollBar(BarState.Off) // 滚动条隐藏

      Row() {
        Sheets({paddingBottom: 78});
      }
      .margin({left: '100vp'})
    }
    .padding({
      top: '35vp'
    })
    // .backgroundColor("#F56C6C")
  }
}