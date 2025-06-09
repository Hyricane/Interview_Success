import axios, { AxiosResponse } from '@ohos/axios'
import { HcSkeleton, HcSkeletonItem, QuestionItemComp } from '.'
import { PageData, QuestionItem, QuestionType, SortType } from '../../models'
import { auth } from '../utils'
import { http } from '../utils/Http'

// 后端返回的分类数据类型
// 这个类型也有讲究!!!
// 后端每次返回的数据都是下面这个造型 唯一不同的是data的类型
// interface CateResType<T> {
//   code: number
//   success: boolean
//   message: string
//   data: T
// }

// interface CateResType2 {
//   code: number
//   success: boolean
//   message: string
//   data: number
// }
//
// interface CateResType3 {
//   code: number
//   success: boolean
//   message: string
//   data: string
// }

// 后端返回的数据类型  不一定要完整的写  用什么写什么
// 每一个分类的类型
// interface CateItemType {
//   id: number
//   name: string
//   icon: string
//
// }

@Component
export struct QuestionListComp {
  @Prop activeIndex:number = 0
  @Prop index:number = 0
  @Prop @Watch('fn') sort:SortType = SortType.Default
  // 传入的分类id
  @Prop typeId: number
  @State list: QuestionItem[] = [] // 文章列表数据 暂时为空
  @State isRefreshing: boolean = false // 是否是下拉状态
  // 节流  请求前打开(true)   请求后关闭(false)
  @State isLoading: boolean = false // 标识当前加载状态
  // 刚开始数据是加载了一部分  等到有一天数据真全获取完了  改true
  @State isFinished: boolean = false // 标识数据是否全部加载完
  @State page: number = 1 // 页码
  fn(){
    if (this.activeIndex == this.index) {
      this.isRefreshing = true
    }
  }
  getList():Promise<PageData> {
    return http.request<PageData>({
      url: 'question/list',
      params: {
        questionBankType: 10, // 表示获取面试题
        type: this.typeId, // 获取哪个分类
        page: 1, // 获取第几页
        pageSize: 10, // 每页获取几条数据
        // 还有一些其他参数
        sort:this.sort,
      }
    })

    // this.list = res.rows // 面试题列表数据
  }
  // 希望组件被下拉时 能够独立维护这部分的逻辑
  async onRefresh() {
    this.page = 1
    const res =await this.getList()
    // const res = await http.request<PageData>({
    //   url: 'question/list',
    //   params: {
    //     questionBankType: 10, // 表示获取面试题
    //     type: this.typeId, // 获取哪个分类
    //     page: this.page, // 获取第几页
    //     pageSize: 10 // 每页获取几条数据
    //     // 还有一些其他参数
    //   }
    // })

    // this.list = []
    this.list = res.rows // 直接清空覆盖

    this.isRefreshing = false

    if (this.list.length == res.total) {
      this.isFinished = true
    } else {
      this.isFinished = false
      this.page++ // 为触底做准备
    }

  }

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


  async onLoad() {
    const res = await this.getList()

    this.list.push(...res.rows)
    // res.rows

    this.isLoading = false

    // res.total 总数
    if (this.list.length == res.total) {
      this.isFinished = true //数据加载完毕
    } else {
      // 数据没有加载完毕  页码++  为下一次触底加载数据做准备
      this.page++
    }
  }

  build() {
    Refresh({ refreshing: $$this.isRefreshing }) {
      // 1. 下拉刷新
      List() {
        ForEach(this.list, (item: QuestionItem) => {
          ListItem() {
            QuestionItemComp({
              item: item,
            })
          }
          .onClick(()=>{
            auth.checkAuth({ url: 'pages/QuestionPage' })
          })
        })

        this.LoadMoreBuilder()
      }
      .onReachEnd(() => {

        if (this.isLoading || this.isFinished || this.isRefreshing) {
          return
        }

        this.isLoading = true // 1 打开开关

        // 2 请求
        this.onLoad()


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
    .onRefreshing(() => {
      this.onRefresh()
    })
  }
}