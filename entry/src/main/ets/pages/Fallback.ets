@Entry
@Component
struct Fallback {
  build() {
    Column({ space: 16 }) {
      Text('页面加载失败')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#172326')

      Text('请稍后重新打开应用')
        .fontSize(15)
        .fontColor('#6B7A80')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding(32)
    .backgroundColor('#F5F8F8')
  }
}
