// 后端返回一个列表数据  ForEach  拿到item
// QuestionItemComp({item: item})

import { HcTag } from ".";
import { QuestionItem } from "../../models";

// 是否为第一个   Extend针对组件封装单独的样式   Style通用样式
@Extend(Text)
function grayText(isStart: boolean = false) {
  .lineHeight(13)
  .fontSize(13)
  .fontColor($r('app.color.common_gray_01'))
  .padding({ left: isStart ? 0 : 12, right: 12 })
}


@Component
export struct QuestionItemComp {
  @Prop item: Partial<QuestionItem> = {}

  build() {
    Column({ space: 10 }) {
      Row({ space: 5 }) {
        HcTag({ difficulty: this.item.difficulty })
        Text(this.item.stem)
          .fontSize(15)
          .layoutWeight(1)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontWeight(500)
      }
      .width('100%')

      // 吃了不看文档的亏!!!
      RowSplit() {
        Text(`点赞 ${this.item.likeCount}`)
          .grayText(true)
        Text(`浏览 ${this.item.views}`)
          .grayText(false)
        Text(this.item.readFlag == 1 ? '已看过' : '未看')
          .grayText()
      }
    }
    .padding({ left: 16, right: 16 })
    .width('100%')
    .height(80)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
  }
}