/**
 * 父组件调用子组件
 * import {SheetMoveListItem, SheetMoveListItemController} from '../../../components/base/SheetMoveListItem'
 *
 * private sheetMoveListItemChildRef = new SheetMoveListItemController()
 *
 * // 把 sheetMoveListItemChildRef 传到子组件，父组件就可以调用 this.sheetMoveListItemChildRef控制器到方法
 * SheetMoveListItem({sheetList: this.sheetList, controller: this.sheetMoveListItemChildRef})
 */

import { JSON, util } from '@kit.ArkTS'
import { SheetEntity } from '../../db/SheetEntity'
import { SkinTheme } from '../../core/Theme'
import SheetDao from '../../db/SheetDao'
import { ArrayList } from '@kit.ArkTS'; //用于存储和管理歌单目录列表

import { ShowDialog, DialogConstants } from '../../components/dialogs/UseDialog'
import { emitter } from '@kit.BasicServicesKit';

// BasicDataSource实现了IDataSource接口，用于管理listener监听，以及通知LazyForEach数据更新
class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: SheetEntity[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): SheetEntity {
    return this.originDataArray[index];
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
      // 写法2：listener.onDatasetChange([{type: DataOperationType.ADD, index: index}]);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
      // 写法2：listener.onDatasetChange([{type: DataOperationType.CHANGE, index: index}]);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
      // 写法2：listener.onDatasetChange([{type: DataOperationType.DELETE, index: index}]);
    })
  }

  notifyDataClear(): void {
    this.originDataArray = [];
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  // 通知LazyForEach组件将from索引和to索引处的子组件进行交换
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
      // 写法2：listener.onDatasetChange(
      //         [{type: DataOperationType.EXCHANGE, index: {start: from, end: to}}]);
    })
  }

  notifyDatasetChange(operations: DataOperation[]): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange(operations);
    })
  }
}

class MyDataSource extends BasicDataSource {
  private dataArray: SheetEntity[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): SheetEntity {
    return this.dataArray[index];
  }

  public getDataAll(): SheetEntity[] {
    return this.dataArray;
  }

  public moveDataWithoutNotify(from: number, to: number): void {
    let tmp = this.dataArray.splice(from, 1);
    this.dataArray.splice(to, 0, tmp[0])
  }

  public pushData(data: SheetEntity): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public async clear() {
    this.dataArray = []
    await this.notifyDataClear()
  }
  public async refresh() {
    await this.notifyDataReload()
  }
}

// 定义声明控制器方法
export class SheetMoveListItemController {
  // 定义子getSheetMoveListItemData方法同名的空方法
  getSheetMoveListItemData = async () => {
    return new Array<SheetEntity>()
  }

}

@Component
export struct SheetMoveListItem {
  // 歌单key
  @Consume musicSheetKey: string;
  @State theme: SkinTheme.Theme = SkinTheme.getTheme();
  @Watch('updateData') @Link sheetList: Array<SheetEntity>;
  private data: MyDataSource = new MyDataSource();
  private showDialog = new ShowDialog()
  // @Watch('updateTest') @Consume refreshListExchangeViewComponent: boolean;

  private controller: SheetMoveListItemController = new SheetMoveListItemController();

  aboutToAppear() {
    // this.controller.getSheetMoveListItemData()
    if (this.controller) {
      // 将子组件方法覆盖控制器方法
      this.controller.getSheetMoveListItemData = this.getSheetMoveListItemData;
    }
  }

  // private async updateTest() {
  //   if (this.refreshListExchangeViewComponent) {
  //     const a: SheetEntity[] = await this.data.getDataAll();
  //     console.log("获取数据====>", JSON.stringify(a));
  //     this.refreshListExchangeViewComponent = false;
  //   }
  // }

  getSheetMoveListItemData = async () => {
    const a: Array<SheetEntity> = await this.data.getDataAll();
    for (let i = 0; i < a.length; i++) {
      a[i].sort = a.length - i;
    }
    return a;
  }

  // async getSheetMoveListItemData() {
  //   const a: Array<SheetEntity> = await this.data.getDataAll();
  //   return a;
  // }

  private async updateData() {
    await this.data.clear()
    for (let sheetListElement of this.sheetList) {
      this.data.pushData(sheetListElement)
    }
  }

  build() {
    List() {
      LazyForEach(this.data, (item: SheetEntity, index: number) => {
        ListItem() {
          Row() {
            if (index == 0) {
              Image($r("app.media.album_default"))
                .width('40vp')
                .height('40vp')
                .margin('10vp')
                .borderRadius(8)

              Image($r("app.media.ic_heart"))
                .width('20vp')
                .height('20vp')
                .margin('10vp')
                .borderRadius(8)
                .fillColor('red')
                // 可以考虑使用堆叠组件替换
                .position({ top: '10vp', left: '10vp' })

            } else {
              Image($r("app.media.album_default"))
                .width('40vp')
                .height('40vp')
                .margin('10vp')
                .borderRadius(8)
            }

            Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
              Column({ space: 5 }) {
                Text(item.title)
                  .fontColor(this.theme.fontColor)
                  .fontSize('14fp')
                Text(`${item.numb ? item.numb : 0}首`)
                  .fontColor(this.theme.subtitleTextColor)
                  .fontSize('10fp')
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)

              if (index != 0) {
                Image($r("app.media.ic_trash_outline"))
                  .width('18vp')
                  .height('18vp')
                  .margin('10vp')
                  .onClick(e => {
                    this.showDialog.openDialog(`确定要删除「${item.title}」吗？`, "温馨提示", false, async () => {
                      console.log("确认删除")
                      await SheetDao.delete(item.sheetKey, item.title)
                      await this.data.refresh();
                      emitter.emit(DialogConstants.SHOW_DIALOG_CONFIRM_EVENT_ID)
                      this.showDialog.currentShowDialog()
                    });
                  })
              }
            }
            .margin({right: '65vp'})

          }
          .position({ bottom: 0, right: 0 })
          .width('100%')
          .justifyContent(FlexAlign.Start)
        }
      }, (item: SheetEntity) => JSON.stringify(item))
        .onMove(async (from: number, to: number) => {
          await this.data.moveDataWithoutNotify(from, to)
          const listItemData = await this.getSheetMoveListItemData();
          await SheetDao.batchUpdateSort(listItemData);
        })
    }
    .divider({ strokeWidth: 2 })
    .width('100%')
  }
}