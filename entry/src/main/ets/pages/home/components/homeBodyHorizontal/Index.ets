
import {Operations} from './Operations'

import {Sheets} from '../Sheets'

@Component
export  struct HomeBodyHorizontal {

  scroller: Scroller = new Scroller()
  build() {
    Row() {
      Column() {
        Flex() {
          Scroll(this.scroller) {
            Operations()
          }
          .flexBasis(100)
          .height('100%')
          .scrollable(ScrollDirection.Vertical) //横向
          .scrollBar(BarState.Off) // 滚动条隐藏

          Sheets();
        }
        .width('100%')
        .height('100%')
        .backgroundColor("#F56C6C")

      }
    }
    .width('100%')
    .height('100%')
  }
}