interface HcTagInfo {
  text: string;
  color: ResourceColor;
}

// 难度tag含有不同的文字和颜色,而后端只传入一个数,用这个数映射一个对象
const infoMap: Record<number, HcTagInfo> = {
  1: { text: "简单", color: $r("app.color.common_green") },
  2: { text: "简单", color: $r("app.color.common_green") },
  3: { text: "一般", color: $r("app.color.common_blue") },
  4: { text: "一般", color: $r("app.color.common_blue") },
  5: { text: "困难", color: $r("app.color.common_main_color") },
};
/**
 * HcTag 组件
 * 1. 支持 difficulty 显示3中颜色标签，1-2是简单，3-4是一般，5是困难
 * 2. 如果 text 或者 bg 传入，则优先使用
 */
@Component
export struct HcTag {
  @Prop difficulty: number = 1
  @Prop text: string = ''
  @Prop color: ResourceColor = ''
  build() {

    Text(this.text || infoMap[this.difficulty].text)
    // infoMap[this.difficulty] 根据 this.difficulty 的值（如 "1"）检索对应的子对象。
      .fontColor(this.color || infoMap[this.difficulty].color)
      .fontSize(10)
      .padding({ left: 6, right: 6 })
      .height(18)
      .constraintSize({ minWidth: 34 })
      .borderRadius(2)
      .backgroundColor($r('app.color.common_gray_bg'))
      .textAlign(TextAlign.Center)
  }
}