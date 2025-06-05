import { QuestionItem, QuestionType } from '../../models'
import { QuestionItemComp } from '.'
@Component
export struct QuestionListComp {
  // 是否加载完成
  @State isFinished: boolean = false
  // 正在加载中...
  @State isLoading: boolean = false
  onRefresh(){
    setTimeout(()=>{
      // 更新数据
      this.list = []
      for (let i = 0; i < 10; i++) {
        this.list.push({} as QuestionItem)
      }
      this.isRefreshing = false
      this.isFinished = false
    },1000)
  }
  onload(){
    setTimeout(()=>{
      for (let i = 0; i < 10; i++) {
        this.list.push({} as QuestionItem)
      }
      this.isLoading = false
      if (this.list.length>=50) {
        this.isFinished = true
      }
    },1000)

  }
  @State list: QuestionItem[] = []
  @State isRefreshing:boolean = false
  @Builder
  LoadMoreBuilder() {
    ListItem() {
      // 加载完成
      if (this.isFinished) {
        Row() {
          Text('没有更多了~')
            .fontSize(14)
            .fontColor($r('app.color.common_gray_03'))
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
      }
      // 没有加载完成且正在加载中
      else if (this.isLoading) {
        Row({ space: 4 }) {
          LoadingProgress()
            .width(20)
          Text('正在加载...')
            .fontSize(14)
            .fontColor($r('app.color.common_gray_03'))
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
      }
    }
    .height(80)
  }



  build() {
    Refresh({ refreshing: $$this.isRefreshing }) {
      List() {
        ForEach(this.list, () => {
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
        this.LoadMoreBuilder()
      }
      .onReachEnd(()=>{
        if (this.isLoading || this.isFinished || this.isRefreshing){
          return
        }
        this.isLoading = true
        this.onload()
      })
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
    .onRefreshing(()=>{
      this.onRefresh()
    })
  }
}