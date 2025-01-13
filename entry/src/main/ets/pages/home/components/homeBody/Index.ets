
import {Operations} from './Operations'

import {Sheets} from '../Sheets'
import { SkinTheme } from '../../../../core/Theme'

@Component
export  struct HomeBody {
  @State theme: SkinTheme.Theme = SkinTheme.getTheme();
  scroller: Scroller = new Scroller()

  build() {
      Column() {
        Scroll(this.scroller) {
          Operations()
        }
        .height('70vp')
        .padding({left: '10vp',right: '10vp'})
        .scrollable(ScrollDirection.Horizontal) //横向
        .scrollBar(BarState.Off) // 滚动条隐藏

        Sheets({paddingBottom: 148});
      }
      .padding({
        top: '35vp'
      })
  }
}