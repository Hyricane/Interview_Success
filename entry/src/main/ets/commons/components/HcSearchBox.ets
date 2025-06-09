@Component
export struct HcSearchBox {
  @Prop boxHeight: number = 32
  @Prop boxWidth: number = 100
  @Prop layoutWeightValue: number = 0
  // 提示文字
  @Prop ph: ResourceStr = '搜索题目'
  // 文字颜色
  @Prop phColor: ResourceColor = $r('app.color.common_gray_02')
  // 背景颜色
  @Prop bgColor: ResourceColor = $r('app.color.common_gray_border')

  build() {
    Row({ space: 4 }) {
      Image($r('app.media.ic_common_search'))
        .width(14)
        .aspectRatio(1)
        .fillColor(this.phColor)

      Text(this.ph)
        .fontSize(14)
        .fontColor(this.phColor)
    }
    .justifyContent(FlexAlign.Center)
    .width(this.boxWidth)
    .layoutWeight(this.layoutWeightValue)
    .height(this.boxHeight)
    .backgroundColor(this.bgColor)
    .borderRadius(this.boxHeight / 2)
  }
}