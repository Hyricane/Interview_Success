import { QuestionItem } from '../../models'
import { QuestionItemComp } from '.'

@Component
export struct QuestionListComp {
  @State list: QuestionItem[] = []
  @State isRefreshing:boolean = false
  build() {
    Refresh({ refreshing: $$this.isRefreshing }) {
      List() {
        ForEach(new Array(10).fill(0), () => {
          ListItem() {
            QuestionItemComp({
              item: {
                id: '100',
                stem: '请说下ArkUI的容器组件有哪些？',
                difficulty: 3,
                likeCount: 23,
                views: 423,
                readFlag: 1
              }
            })
          }
        })
      }
      .divider({
        strokeWidth: 0.5,
        color: $r('app.color.common_gray_border'),
        startMargin: 16,
        endMargin: 16
      })
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.None)
    }
  }
}