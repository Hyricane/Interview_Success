import { FilterButton, HcTag, QuestionItemComp, QuestionListComp } from "../commons/components"
import { http } from "../commons/utils"
import { QuestionType } from "../models"

@Extend(Text)
function textTitle() {
  .fontSize(14)
  .fontWeight(500)
  .fontColor($r('app.color.black'))
  .width('100%')
  .margin({ top: 20 })
}
@Component
export struct HomeCategory {
  // 将来请求后端的数据
  @State list: QuestionType[] = []
  @State activeIndex: number = 0
  @State isShow: boolean = false
  aboutToAppear(): void {
    this.getCategory()
  }

  async getCategory() {
    // 请求分类
    const res = await http.request<QuestionType[]>({ url: 'question/type' })
    this.list = res // 分类数组
  }

  @Builder
  TabBarBuilder(item: QuestionType, index: number) {
    Row() {
      Stack({ alignContent: Alignment.Bottom }) {
        Text(item.name)
          .height(44)
          .fontSize(15)
          .fontColor(this.activeIndex == index ? $r('app.color.black') : $r('app.color.common_gray_01'))

        Text()
          .width(this.activeIndex == index ? 20 : 0)
          .height(2)
          .backgroundColor($r('app.color.black'))
          .animation({ duration: this.activeIndex == index ? 300 : 0 })
      }

      if (item.displayNewestFlag == 1) {
        Image($r('app.media.ic_home_new'))
          .width(32)
          .height(14)
          .objectFit(ImageFit.Contain)
          .margin({ left: 4 })
      }
    }
    .padding({ left: 16 })
  }
  @Builder
  FilterSheetBuilder() {
    Column() {
      Row() {
        Text('重置')
          .fontSize(16)
          .fontWeight(500)
          .fontColor($r('app.color.common_gray_03'))
        Text('筛选题目')
          .layoutWeight(1)
          .fontSize(18)
          .fontWeight(500)
          .fontColor($r('app.color.black'))
          .textAlign(TextAlign.Center)
        Text('完成')
          .fontWeight(500)
          .fontSize(16)
          .fontColor($r('app.color.common_main_color'))
      }
      .margin({ bottom: 4, top: 4 })

      Text('题目排序')
        .textTitle()
      // TODO 筛选按钮
      // 排序方式
      Flex({ wrap: FlexWrap.Wrap }) {
        FilterButton({ text: '默认'})
        FilterButton({
          text: '浏览量',
          isSort: true,
        })
        FilterButton({
          text: '难度',
          isSort: true,
        })
        FilterButton({ text: '推荐'})
      }
      Text('选择分类')
        .textTitle()
      // TODO 筛选按钮
      // 选择分类
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.list, (item: QuestionType) => {
          FilterButton({
            text: item.name,
            isNew: item.displayNewestFlag === 1,
          })
        })
      }
    }
    .padding(16)
    .backgroundColor($r('app.color.white'))
    .height('100%')
  }


  build() {
    Stack({alignContent: Alignment.TopEnd}){
      Tabs({ index: this.activeIndex }) {
        ForEach(this.list, (item: QuestionType, index: number) => {
          TabContent() {
            QuestionListComp({
              typeId: item.id // 分类id传入  将来根据分类id获取分类列表数据 渲染
            })
          }.tabBar(this.TabBarBuilder(item, index))
        })
      }
      .onTabBarClick((index) => {
        this.activeIndex = index
      })
      .animationDuration(0)
      .barMode(BarMode.Scrollable)
      .barHeight(44)
      .scrollable(false)
      .divider({ strokeWidth: 0.5, color: $r('app.color.common_gray_border') })
      Row() {
        Image($r('app.media.ic_home_filter'))
          .width(24)
          .aspectRatio(1)
      }
      .width(56)
      .height(44)
      .justifyContent(FlexAlign.Center)
      .linearGradient({ angle: 90, colors: [['#00FFFFFF', 0], ['#FFFFFF', 0.285]] })
      .bindSheet($$this.isShow, this.FilterSheetBuilder(), {
        showClose: false,
        height: 400
      })
      .onClick(() => {
        this.isShow = true
      })
    }
  }
}