// 自定义弹窗装饰器
@CustomDialog
export struct HcLoadingDialog {
  // 控制器控制组件的开关
  // 控制器应该是外部new好的  控制组件自身
  xx: CustomDialogController
  // 文案
  @Prop message: string = '加载中...'

  build() {
    Column() {
      Column({ space: 10 }) {
        LoadingProgress()
          .width(48)
          .height(48)
          .color($r('app.color.white'))
        if (this.message) {
          Text(this.message)
            .fontSize(14)
            .fontColor($r('app.color.white'))
        }
      }
      .justifyContent(FlexAlign.Center)
      .width(120)
      .height(120)
      .backgroundColor('rgba(0,0,0,0.6)')
      .borderRadius(16)
    }
  }
}