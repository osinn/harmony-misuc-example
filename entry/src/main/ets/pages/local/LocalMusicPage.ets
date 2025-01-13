
// import {Header} from '../../components/base/Header'
import { Header } from "../../components/base/Header";
import { StyleConstants } from "../../constants/StyleConstants";

@Entry
@Component
export struct LocalMusicPage {

  @StorageLink('deviceHeight') deviceHeight: number = 0;

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Header()
    }
    .width(StyleConstants.FULL_WIDTH)
    // .backgroundColor(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ?
    // $r('app.color.page_background_sm') : $r('app.color.page_background_other'))
    .onAreaChange((oldArea: Area, newArea: Area) => {
      if (typeof newArea.height === 'number') {
        this.deviceHeight = newArea.height;
      }
    })
  }
}