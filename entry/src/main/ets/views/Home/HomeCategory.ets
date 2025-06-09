import { FilterButton,
  HcSkeleton,
  HcSkeletonItem, HcTag, QuestionItemComp, QuestionListComp } from "../../commons/components"
import { http } from "../../commons/utils"
import { QuestionType, SortType } from "../../models"
import { emitter } from "@kit.BasicServicesKit"

import { LOGIN_EVENT} from '../../commons/constants'
// 只支持全局
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
  // 表示当前的分类下标
  @State activeIndex: number = 0
  // 筛选半模态的显示隐藏
  @State isShow: boolean = false
  // 记录筛选半模态中  选择分类的下标
  @State filterDataIndex: number = 0
  // 记录筛选半模态中  题目排序  SortType
  @State filterDataSort: SortType = SortType.Default
  // 记录真正的排序方式  完成才是真正确认下来
  @State sort: SortType = SortType.Default
  @State firstLoad:boolean = true

  // 筛选模态框的结构 builder
  @Builder
  FilterSheetBuilder() {
    Column() {
      Row() {
        Text('重置')
          .fontSize(16)
          .fontWeight(500)
          .fontColor($r('app.color.common_gray_03'))
          .onClick(() => {
            // 重置我们分类 排序方式
            this.filterDataIndex = 0
            this.filterDataSort = SortType.Default
          })
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
          .onClick(() => {
            this.isShow = false // 关半模态
            this.activeIndex = this.filterDataIndex // 用户打开半模态 选中的分类下标   存下来
            this.sort = this.filterDataSort // 用户打开半模态 选中的排序方式
          })
      }
      .margin({ bottom: 4, top: 4 })

      Text('题目排序')
        .textTitle()
      Flex({ wrap: FlexWrap.Wrap }) {
        FilterButton({
          text: '默认',
          isSelect: this.filterDataSort == SortType.Default
        })
          .onClick(() => {
            this.filterDataSort = SortType.Default
          })
        FilterButton({
          text: '浏览量',
          isSort: true,
          isSelect: this.filterDataSort == SortType.Low2High || this.filterDataSort == SortType.High2Low,
          sort: this.filterDataSort // 传入具体的排序方式  控制箭头
        })
          .onClick(() => {
            // this.filterDataSort = SortType.Low2High
            if (
              this.filterDataSort == SortType.Low2High
                || this.filterDataSort == SortType.High2Low) {
              this.filterDataSort =
                this.filterDataSort == SortType.Low2High
                  ? SortType.High2Low : SortType.Low2High
            } else {
              this.filterDataSort = SortType.Low2High // 第一次 低到高
            }
          })
        FilterButton({
          text: '难度',
          isSort: true,
          isSelect: this.filterDataSort == SortType.Easy2Hard || this.filterDataSort == SortType.Hard2Easy,
          sort: this.filterDataSort
        })
          .onClick(() => {
            // 难度如果是第一次点击  记录 Easy2Hard 易到难
            // 如果不是第一次点击  Easy2Hard 改 Hard2Easy;  Hard2Easy改Easy2Hard
            if (
              this.filterDataSort == SortType.Easy2Hard
                ||
                this.filterDataSort == SortType.Hard2Easy
            ) {
              this.filterDataSort =
                this.filterDataSort == SortType.Easy2Hard ?
                SortType.Hard2Easy : SortType.Easy2Hard
            } else {
              this.filterDataSort = SortType.Easy2Hard
            }
          })
        FilterButton({
          text: '推荐',
          isSelect: this.filterDataSort == SortType.Recommend
        })
          .onClick(() => {
            this.filterDataSort = SortType.Recommend
          })
      }

      Text('选择分类')
        .textTitle()
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.list, (item: QuestionType, index: number) => {
          FilterButton({
            text: item.name,
            isNew: item.displayNewestFlag == 1,
            isSelect: this.filterDataIndex == index // 是否高亮的结果传入组件  控制组件内部的文字颜色
          })// .fontColor(this.filterDataIndex == index?Red:Black)
            .onClick(() => {
              this.filterDataIndex = index
            })
        })

      }
    }
    .padding(16)
    .backgroundColor($r('app.color.white'))
    .height('100%')
  }

  @Builder
  SkeletonBuilder() {
    HcSkeleton() {
      Column() {
        Row({ space: 16 }) {
          HcSkeletonItem({ widthValue: 60 })
          HcSkeletonItem({ widthValue: 100 })
          HcSkeletonItem({ widthValue: 80 })
          HcSkeletonItem({ widthValue: 40 })
        }
        .height(44)
        .width('100%')

        ForEach([1, 2, 3, 4, 5, 6], () => {
          Column({ space: 10 }) {
            HcSkeletonItem({ widthValue: '90%' })
            HcSkeletonItem({ widthValue: '45%' })
          }
          .height(80)
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
        })
      }
      .padding({ left: 16, right: 16 })
    }
  }

  aboutToAppear(): void {
    this.getCategory()
    emitter.on(LOGIN_EVENT,()=>{
      this.getCategory()
    })
  }

  async getCategory() {
    // 请求分类
    const res = await http.request<QuestionType[]>({ url: 'question/type' })
    this.list = res // 分类数组
    this.firstLoad =false
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
    Stack({ alignContent: Alignment.TopEnd }) {
      if (this.firstLoad){
        this.SkeletonBuilder()
      }else {
        Tabs({ index: this.activeIndex }) {
          // { id: , name: , 是否最新: true/false }
          ForEach(this.list, (item: QuestionType, index: number) => {
            TabContent() {
              // Text(item.name)
              // HcTag({ text: '地狱', color: '#8df' })
              // QuestionItemComp({
              //   item: {
              //     id: '1',
              //     stem: '如何删除Record中的元素',
              //     likeCount: 3,
              //     views: 1738,
              //     readFlag: 1,
              //     difficulty: 5
              //   }
              //
              // })

              QuestionListComp({
                typeId: item.id, // 分类id传入  将来根据分类id获取分类列表数据 渲染
                sort: this.sort, // 用户最终确认的排序方式
                activeIndex: this.activeIndex, // 当前选中的tab
                index: index // 自己的下标
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
        showClose: false, // 关闭按钮 不要
        height: 400 // 高度
      })
      .onClick(() => {
        this.isShow = true // 打开
        this.filterDataIndex = this.activeIndex //将外面tab高亮带给半模态
      })
    }
  }
}