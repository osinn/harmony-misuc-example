
import {Operations} from './Operations'

import {Sheets} from '../Sheets'

@Component
export  struct HomeBody {

  scroller: Scroller = new Scroller()
  build() {
    Row() {
      Column() {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Scroll(this.scroller) {
            Operations()
          }
          .scrollable(ScrollDirection.Horizontal) //横向
          .scrollBar(BarState.Off) // 滚动条隐藏
        }
        .width('100%')
        .padding({left: '10vp',right: '10vp'})
        .height('80vp')
        .backgroundColor("#1a182431")

        Sheets();
      }
    }
    .height('100%')
  }
}