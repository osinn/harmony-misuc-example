
import {Operations} from './Operations'

import {Sheets} from '../Sheets'
import { SkinTheme } from '../../../../core/Theme'

@Component
export  struct HomeBody {
  @State theme: SkinTheme.Theme = SkinTheme.getTheme();
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
        .backgroundColor(this.theme.pageBackgroundColor)

        Sheets();
      }
    }
    .height('100%')
  }
}