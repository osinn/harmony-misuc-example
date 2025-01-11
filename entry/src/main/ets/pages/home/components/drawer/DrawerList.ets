import { App } from "@kit.ArkUI";
import { bundleManager } from "@kit.AbilityKit";

class itemType {
  id: number = -1
  typeName: string = ''
}
let listData: Array<object> = [
  {
    id: 1,
    typeName: 'ikf-min4',
  } as itemType,
  {
    id: 2,
    typeName: 'ikf-Find Air-4'
  } as itemType,
  {
    id: 3,
    typeName: 'ikf-Sky'
  } as itemType,
  {
    id: 4,
    typeName: 'ikf-Find Air-5'
  } as itemType,
  {
    id: 5,
    typeName: 'ikf-Zeus'
  } as itemType,
  {
    id: 6,
    typeName: 'ikf-Fly'
  } as itemType,
  {
    id: 7,
    typeName: 'ikf-min4',
  } as itemType,
  {
    id: 8,
    typeName: 'ikf-Find Air-4'
  } as itemType,
  {
    id: 9,
    typeName: 'ikf-Sky'
  } as itemType,
  {
    id: 10,
    typeName: 'ikf-Find Air-5'
  } as itemType,
  {
    id: 11,
    typeName: 'ikf-Zeus'
  } as itemType,
  {
    id: 12,
    typeName: 'ikf-Fly'
  } as itemType,
  {
    id: 13,
    typeName: 'ikf-Find Air-6'
  } as itemType,
  {
    id: 14,
    typeName: 'ikf-Zeus-1'
  } as itemType,
  {
    id: 15,
    typeName: 'ikf-Fly-3'
  } as itemType,
];
@Component
export  struct DrawerList {
  scroller: Scroller = new Scroller()
  @Builder
  itemBuilder(item:itemType) {
    Row() {
      Text(item.typeName)
        .fontSize(16)
        .fontColor('#333')
    }
    .width('100%')
    .padding(20)
    .justifyContent(FlexAlign.SpaceBetween)
  }
  aboutToAppear(): void {
  }

  @Builder
  itemHead(text: string) {
    Text(text)
      .fontSize(20)
      .backgroundColor(0xAABBCC)
      .width("100%")
      .padding(10)
  }

  build() {
    Column() {
      Scroll(this.scroller) {
        Column() {
          Row() {
           Text($r("app.string.app_name"))
             .onClick(() => {
             })
          }
          .alignItems(VerticalAlign.Center)
          .backgroundColor('#fff')
          .height('40vp')
          .width('100%')

          List() {
              ListItemGroup({ header: this.itemHead('分组2') }) {
                  ForEach(listData, (item: itemType) => {
                    ListItem() {
                      this.itemBuilder(item)
                    }
                  }, (item: itemType) => JSON.stringify(item))
              }
          }
          //
          // List() {
          //   ForEach(listData, (item: itemType) => {
          //     ListItem() {
          //       this.itemBuilder(item)
          //     }
          //   }, (item: itemType) => JSON.stringify(item))
          // }
          // .backgroundColor('#fff')
          // .borderRadius(10)
          // .margin({bottom: 20})
          // List() {
          //   ForEach(listData, (item: itemType) => {
          //     ListItem() {
          //       this.itemBuilder(item)
          //     }
          //   }, (item: itemType) => JSON.stringify(item))
          // }
          // .backgroundColor('#fff')
          // .borderRadius(10)
        }
      }
      // .scrollBar(BarState.Off)
    }
    .height('100%')
    // .padding({left: 15, right: 15, top: 15})
    .backgroundColor("#f7f7f7")
  }
}