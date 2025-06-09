import { SortType } from "../../models"

@Component
export struct FilterButton {
  // ! @Prop 单向同步接收外部的数据
  // ! 不加 就收一次数据

  // 显示文字
  text: string = ''
  // 是否展示new
  isNew: boolean = false
  // 是否展示右侧排序箭头
  isSort: boolean = false
  // 控制高亮
  @Prop isSelect: boolean = false
  // 接收外部传入的具体排序方式 20 21     10 11
  @Prop sort: SortType = SortType.Default

  build() {
    Row() {
      Text(this.text)
        .fontSize(12)
        .fontColor(this.isSelect ? $r('app.color.common_main_color') : $r('app.color.black'))
      if (this.isNew) {
        Image($r('app.media.ic_home_new'))
          .width(32)
          .height(14)
          .objectFit(ImageFit.Contain)
          .position({ right: -26, top: -7 })
      }
      if (this.isSort) {
        Column() {
          Image($r('sys.media.ohos_ic_public_arrow_up'))
            .size({ width: 12, height: 6 })// 上箭头亮还是不亮
              // 上箭头亮  本身isSelect就是true  我还是10或者20这种偶数
            .fillColor(this.isSelect && this.sort % 2 == 0 ? $r('app.color.common_main_color') : $r('app.color.black'))
          Image($r('sys.media.ohos_ic_public_arrow_down'))
            .size({ width: 12, height: 6 })
            .fillColor(this.isSelect && this.sort % 2 == 1 ? $r('app.color.common_main_color') : $r('app.color.black'))

        }
        .margin({ top: -0.5, left: 2 })
      }
    }
    .height(30)
    .padding({ left: 10, right: 10 })
    .backgroundColor($r('app.color.common_gray_bg'))
    .borderRadius(4)
    .margin({ top: 12, right: this.isNew ? 26 : 10 })
  }
}