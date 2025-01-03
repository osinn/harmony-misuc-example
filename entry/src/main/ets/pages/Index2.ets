// Index.ets
import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { Environment } from '@kit.CoreFileKit';
import { fileIo as fs } from '@kit.CoreFileKit';

import { Plugin } from '../core/pluginManager'

import featureAbility from '@ohos.ability.featureAbility';


const permissions: Array<Permissions> =
  ['ohos.permission.READ_WRITE_DOWNLOAD_DIRECTORY', 'ohos.permission.READ_WRITE_DOCUMENTS_DIRECTORY'];

// 使用UIExtensionAbility：将common.UIAbilityContext 替换为common.UIExtensionContext
function reqPermissionsFromUser(permissions: Array<Permissions>, context: common.UIAbilityContext): void {
  console.log('点击请求授权');
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
  atManager.requestPermissionsFromUser(context, permissions).then((data) => {
    let grantStatus: Array<number> = data.authResults;
    let length: number = grantStatus.length;
    for (let i = 0; i < length; i++) {
      if (grantStatus[i] === 0) {
        // 用户授权，可以继续访问目标操作
        console.log('用户授权，可以继续访问目标操作');
      } else {
        // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
        console.log('用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限');
        return;
      }
    }
    // 授权成功
  }).catch((err: BusinessError) => {
    console.error(`Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`);
  })
}

const plugin = new Plugin("方法code", "插件路径");

function testPlugin() {


  console.log("测试插件");
  console.log("调用插件方法插件", plugin.getPluginPath());
}

function getUserDirExample() {
  console.log("获取目录");
  let basePath = null;
  try {
    const downloadPath = Environment.getUserDownloadDir();
    console.info(`下载目录: ${downloadPath}`);
    const documentsPath = Environment.getUserDocumentDir();
    console.info(`获取文档目录: ${documentsPath}`);

    const basePath = downloadPath.substring(0, downloadPath.lastIndexOf('/'));
    console.log("根目录", basePath);

    // fs.mkdir(`${basePath}/demo` ).catch((err: BusinessError) => {
    //   console.error("创建目录失败: " + err.message + ", error code: " + err.code);
    // });
    // 拷贝文件到下载目录下

    // fs.access(`${basePath}/test/test.txt`).then((res: boolean) => {
    //   if (res) {
    //     console.info("文件存在");
    //   } else {
    //     console.info("文件不存在");
    //   }
    // }).catch((err: BusinessError) => {
    //   console.error("访问错误: " + err.message + ", error code: " + err.code);
    // });

    fs.access(`${downloadPath}/demo.js`).then((res: boolean) => {
      if (res) {
        console.info(`目录存在${downloadPath}/demo.ts`);
        // let _instance = Function()
        // import(`/@/storage/Users/currentUser/Download/demo.ts`).then((obj: ESObject) => {
        //   console.info(obj.add(3, 5));
        // }).catch((err: Error) => {
        //   console.error("Module dynamic import error: ", err);
        // });
        // import("./Calc").then((obj: ESObject) => {
        //   console.info("相加：：",obj.add(3, 5));
        // }).catch((err: Error) => {
        //   console.error("Module dynamic import error: ", err);
        // });
        console.log("初始化")
      } else {
        console.info("目录不存在");
      }
    }).catch((err: BusinessError) => {
      console.error("访问错误: " + err.message + ", error code: " + err.code);
    });


  } catch (error) {
    const err: BusinessError = error as BusinessError;
    console.error(`获取目录失败: ${JSON.stringify(err)}`);
  }

  // if (basePath != null) {
  //   try {
  //     fs.copyFileSync(`${basePath}/test/test.txt`,`${basePath}/demo/test.txt`);
  //   } catch (error) {
  //     const err: BusinessError = error as BusinessError;
  //     console.error(`复制文件失败: ${JSON.stringify(err)}`);
  //   }
  // }

  // let filePath = '/test/test.txt';
  // // 查看 Download 目录下的文件并拷贝到沙箱目录中
  // let fileList: string[] = fs.listFileSync(downloadPath);
  // fileList.forEach((file, index) => {
  //   console.info(`${downloadPath} ${index}: ${file}`);
  //   fs.copyFileSync(`${downloadPath}/${file}`, `${dirPath}/${file}`);
  // });
  // // 查看沙箱目录下对应的文件
  // fileList = fs.listFileSync(dirPath);
  // fileList.forEach((file, index) => {
  //   console.info(`${dirPath} ${index}: ${file}`);
  // });
}

@Entry
@Component
struct Index {
  @State message: string = '主页'
  @State searchKey: string = ''

  build() {
    Row() {
      Column() {
        Flex() {
          Image($r("app.media.ic_list_bullet"))
            .width('20vp')
            .height('18vp')
            .onClick(e => {
              console.log("点击搜索：" + this.searchKey);
            })

          Search({
            placeholder: '点击这里开始搜索'
          })
            .onChange(e => {
              console.log("输入内容：" + e);
              this.searchKey = e;
            })
        }
      }

      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        // 添加按钮，以响应用户点击
        Button() {
          Text('Next')
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
        .onClick(() => {
          console.log("点击事件哈哈哈")
          router.pushUrl({ url: 'pages/Second', params: { "name": "测试传参数" } })
        })

        // 添加按钮，以响应用户点击
        Button() {
          Text('授权')
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
        .onClick(() => {
          // 使用UIExtensionAbility：将common.UIAbilityContext 替换为common.UIExtensionContext
          const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
          reqPermissionsFromUser(permissions, context);
        })

        // 添加按钮，以响应用户点击
        Button() {
          Text('获取路径')
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
        .onClick(() => {
          // testPlugin();
          getUserDirExample()
        })

      }
      .width('100%')
    }
    .height('100%')
  }
}