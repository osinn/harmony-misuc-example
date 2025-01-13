import { displaySync } from '@kit.ArkGraphics2D';
import { BreakpointType } from '../../utils/BreakpointSystem';
@Component
export struct MusicBar {

  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Vertical });

  @State imageRotate: number = 0;

  @StorageLink('isPlay') @Watch('animationFun') isPlay: boolean = false;
  // @State isPlay: boolean = false

  // @StorageLink('isShowPlay') isShowPlay: boolean = false;

  @State isShowPlay: boolean = false;

  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm'//BreakpointConstants.BREAKPOINT_SM;

  private backDisplaySyncSlow: displaySync.DisplaySync | undefined = undefined;

  private drawFrame: (value: displaySync.IntervalInfo) => void = (value: displaySync.IntervalInfo) => {
    if (this.imageRotate >= 360 ) {
      this.imageRotate = 0;
    }
    this.imageRotate += 1;
  };

  animationFun() {
    if (this.isPlay) {
      this.backDisplaySyncSlow?.start();
    } else {
      this.backDisplaySyncSlow?.stop();
    }

  }

  aboutToAppear() {
    let range : ExpectedFrameRateRange = {
      expected: 30,
      min: 0,
      max: 30
    };

    this.backDisplaySyncSlow = displaySync.create();
    this.backDisplaySyncSlow.setExpectedFrameRateRange(range);
    this.backDisplaySyncSlow.on('frame', this.drawFrame);
  }

  aboutToDisappear(): void {
    this.backDisplaySyncSlow?.off('frame', this.drawFrame);
  }

  build() {
    Row() {
      Row() {
        Image($r('app.media.ic_dream'))
          .height('32vp')
          .width('32vp')
          .borderRadius('16vp')
          .margin({ right: '12vp' })
          .rotate({ angle: this.imageRotate })
          .onAppear(() => {
            this.animationFun();
          })
        Column() {
          Text("中国人")
            // $r('app.color.song_name')
            .fontColor('#000000')
            .fontSize(new BreakpointType({
              // $r('app.float.song_title_sm'
              sm: '14fp',
              // $r('app.float.song_title_md')
              md: '16fp',
              // $r('app.float.song_title_lg')
              lg: '18fp'
            }).getValue(this.currentBreakpoint))
          Row() {
            // Image($r('app.media.ic_vip'))
            //   .height($r('app.float.vip_icon_height'))
            //   .width($r('app.float.vip_icon_width'))
            //   .margin({ right: $r('app.float.vip_icon_margin') })
            // 歌手
            Text('刘德华')
              // $r('app.color.singer')
              .fontColor('#000000')
              .fontSize(new BreakpointType({
                // $r('app.float.singer_title_sm')
                sm: '10fp',
                // $r('app.float.singer_title_md')
                md: '12fp',
                // $r('app.float.singer_title_lg')
                lg: '14fp'
              }).getValue(this.currentBreakpoint))
              .opacity($r('app.float.singer_opacity'))
          }
        }
        .alignItems(HorizontalAlign.Start)
      }
      .layoutWeight(1)
      .onClick(() => {
        // this.isShowPlay = true;
      })

      Blank()
        .onClick(() => {
          console.log("点击了 ====> Blank")
          this.isShowPlay = true;
        })


      Row() {
        Image($r('app.media.ic_previous'))
          .height($r('app.float.control_icon_height'))
          .width($r('app.float.control_icon_width'))
          .margin({ right: $r('app.float.control_icon_margin') })
          // PlayerConstants.DISPLAY_PRIORITY_TWO
          .displayPriority(2)
          .onClick(() => {
            // MediaService.getInstance().playPrevious()
          })
        Image(this.isPlay ? $r('app.media.ic_play') : $r('app.media.ic_pause'))
          .height($r('app.float.control_icon_height'))
          .width($r('app.float.control_icon_width'))
          // PlayerConstants.DISPLAY_PRIORITY_THREE
          .displayPriority(3)
          .onClick(() => {
            console.log("播放状态", !this.isPlay)
            AppStorage.setOrCreate<boolean>('isPlay', !this.isPlay);
            // this.isPlay = !this.isPlay
            // if (MediaService.getInstance().getFirst()) {
            //   MediaService.getInstance().loadAssent(0);
            // } else {
            //   this.isPlay ? MediaService.getInstance().pause() : MediaService.getInstance().play();
            // }
          })
        Image($r('app.media.ic_next'))
          .height($r('app.float.control_icon_height'))
          .width($r('app.float.control_icon_width'))
          .margin({
            right: $r('app.float.control_icon_margin'),
            left: $r('app.float.control_icon_margin')
          })
          // PlayerConstants.DISPLAY_PRIORITY_TWO
          .displayPriority(2)
          .onClick(() => {
            // MediaService.getInstance().playNextAuto(true)
          })
        Image($r('app.media.ic_music_list'))
          .height($r('app.float.control_icon_height'))
          .width($r('app.float.control_icon_width'))
          // PlayerConstants.DISPLAY_PRIORITY_ONE
          .displayPriority(1)
      }
      .width(new BreakpointType({
        sm: $r('app.float.play_width_sm'),
        md: $r('app.float.play_width_sm'),
        lg: $r('app.float.play_width_lg')
      }).getValue(this.currentBreakpoint))
      .justifyContent(FlexAlign.End)
    }
    .height('48vp')
    .backgroundColor('#EBEEF5')

    .width('100%')
    .height('48vp')
    // .bindContentCover($$this.isShowPlay, this.musicPlayBuilder(), ModalTransition.DEFAULT)
    .padding({
      left: '16vp',
      right: '16vp'
    })
    .position({
      x: 0,
      y: '100%'
    })
    .translate({
      x: 0,
      y: '-48vp'
    })
    .gesture(
      PanGesture(this.panOption)
        .onActionEnd((event?: GestureEvent) => {
          if (event && event.offsetY < -10) {
          }
        })
    )
  }
}