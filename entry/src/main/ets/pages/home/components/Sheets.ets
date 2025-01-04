@Component
export struct Sheets {
  build() {
    Row() {
      Column() {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor("#E6A23C")

          Column()
            // .flexBasis(200)
            .width(100)
            .height('100%')
            .backgroundColor("#F56C6C")
            .justifyContent(FlexAlign.End)
        }
        .backgroundColor("#E6A23C")
        .width('100%')
        .height('30vp')

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {

        }
        .height('100%')
        .width('100%')
        .backgroundColor("#67C23A")
      }
      .width('100%')
      .height('100%')
    }
  }
}