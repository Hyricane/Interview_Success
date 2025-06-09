interface HcTagInfo {
  text: string;
  color: ResourceColor;
}

// 需要将后端返回的数值 映射成 我们需要的数据格式
// Record<T, K>  给你对象类型  T键   K值
let obj: Record<number, HcTagInfo> = {
  1: { text: '简单', color: Color.Green },
  2: { text: '简单', color: Color.Green },
  3: { text: '一般', color: Color.Blue },
  4: { text: '一般', color: Color.Blue },
  5: { text: '困难', color: Color.Orange },
}

// 对象的取值方式
// 1. obj.name  obj.age
// 2. obj['name']   obj['age']

// 考虑到组件可扩展   地狱  Red
@Component
export struct HcTag {
  // 12简单   34一般   5困难
  @Prop difficulty: number = 1
  // 自定义组件文字 为主
  @Prop text: string = ''
  // 自定义组件颜色
  @Prop color: ResourceColor = ''

  build() {
    // 一真则真 逻辑或的短路 简化判断
    Text(this.text || obj[this.difficulty].text)
      .fontColor(this.color || obj[this.difficulty].color)
      .padding(5)
      .backgroundColor($r('app.color.common_gray_bg'))
      .borderRadius(5)
  }
}