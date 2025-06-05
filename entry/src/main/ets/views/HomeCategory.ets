import { HcTag, QuestionItemComp, QuestionListComp } from "../commons/components"
import { http } from "../commons/utils"
import { QuestionType } from "../models"


@Component
export struct HomeCategory {
  // 将来请求后端的数据
  @State list: QuestionType[] = []
  @State activeIndex: number = 0

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

  build() {
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
  }
}