import window from '@ohos.window';
import display from '@ohos.display';

const TAG = 'foo'
const ORIENTATION: Array<string> = ['垂直', '水平', '反向垂直', '反向水平']

@Component
struct UseOrientation {
  @State rotation: number = 0
  @State message: string = ORIENTATION[this.rotation]

  aboutToAppear() {
    this.setOrientation()

    let callback = async () => {
      let d = await display.getDefaultDisplaySync()
      this.rotation = d.rotation
      this.message = ORIENTATION[this.rotation]
      console.info(TAG, JSON.stringify(d))
    }
    try {
      display.on("change", callback); //监听屏幕状态改变
    } catch (exception) {
      console.error(TAG, 'Failed to register callback. Code: ' + JSON.stringify(exception));
    }
  }

  setOrientation() {
    try {
      window.getLastWindow(getContext(this), (err, data) => { //获取window实例
        if (err.code) {
          console.error(TAG, 'Failed to obtain the top window. Cause: ' + JSON.stringify(err));
          return;
        }
        let windowClass = data;
        console.info(TAG, 'Succeeded in obtaining the top window. Data: ' + JSON.stringify(data));

        let orientation = window.Orientation.AUTO_ROTATION; //设置窗口方向为传感器自动旋转模式。
        try {
          windowClass.setPreferredOrientation(orientation, (err) => {
            if (err.code) {
              console.error(TAG, 'Failed to set window orientation. Cause: ' + JSON.stringify(err));
              return;
            }
            console.info(TAG, 'Succeeded in setting window orientation.');
          });
        } catch (exception) {
          console.error(TAG, 'Failed to set window orientation. Cause: ' + JSON.stringify(exception));
        }
        ;
      });
    } catch (exception) {
      console.error(TAG, 'Failed to obtain the top window. Cause: ' + JSON.stringify(exception));
    }
    ;
  }

  build() {
    Row() {
      Column() {
        Text(`${this.rotation}`).fontSize(25)
        Text(`${this.message}`).fontSize(25)
      }
      .width("100%")
    }
    .height("100%")
  }
}