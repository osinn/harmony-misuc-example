// Second.ets

import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

let obj = router.getParams()

@Entry
@Component
struct Second {
  @State message: string = 'Hi there'

  private context = getContext(this) as common.ExtensionContext;

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button() {
          Text('Back11')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .width('40%')
        .height('5%')
        .onClick(() =>{
          // let applicationContext = this.context.getApplicationContext();
          // let cacheDir = this.context.cacheDir;
          // let tempDir = this.context.tempDir;
          // let filesDir = this.context.filesDir;
          // let databaseDir = this.context.databaseDir;
          // let bundleCodeDir = this.context.bundleCodeDir;
          // let distributedFilesDir = this.context.distributedFilesDir;
          // let preferencesDir = this.context.preferencesDir;
          // let cloudFileDir = applicationContext.cloudFileDir;
          //
          //
          // let filePath = '/data/storage/el2/test/test.txt';
          //
          // console.log("1212文件路径：")
          // console.log(cacheDir)
          // console.log(tempDir)
          // console.log(filesDir)
          // console.log(databaseDir)
          // console.log(bundleCodeDir)
          // console.log(distributedFilesDir)
          // console.log(preferencesDir)
          // console.log(cloudFileDir)
          // console.log("获取传递参数121：", JSON.stringify(obj))
          router.back()
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}