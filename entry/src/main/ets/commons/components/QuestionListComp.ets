import axios, { AxiosResponse } from '@ohos/axios'
import { HcSkeleton, QuestionItemComp } from '.'
import { PageData, QuestionItem, QuestionType, SortType } from '../../models'
import { http } from '../utils/Http'
import { router } from '@kit.ArkUI'
import { auth } from '../utils'

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
  @Prop activeIndex: number = 0 // 哪个tab被选中 将来应该更新哪个list
  @Prop index: number = 0 // 每个list对应的下标
  @Prop @Watch('fn') sort: SortType = SortType.Default
  // 传入的分类id
  @Prop typeId: number
  @State list: QuestionItem[] = [] // 文章列表数据 暂时为空
  @State isRefreshing: boolean = false // 是否是下拉状态
  // 节流  请求前打开(true)   请求后关闭(false)
  @State isLoading: boolean = false // 标识当前加载状态
  // 刚开始数据是加载了一部分  等到有一天数据真全获取完了  改true
  @State isFinished: boolean = false // 标识数据是否全部加载完
  @State page: number = 1 // 页码

  fn() {
    // 该我更新我才更新
    if (this.activeIndex == this.index) {
      AlertDialog.show({ message: 'sort变了' })
      this.isRefreshing = true // 拉下来
    }
  }

  async getList() {
    const res = await http.request<PageData>({
      url: 'question/list',
      params: {
        questionBankType: 10, // 表示获取面试题
        type: this.typeId, // 获取哪个分类
        page: this.page, // 获取第几页
        pageSize: 10, // 每页获取几条数据
        sort: 0 // 10 11 20 21 30  表示排序方式  枚举优化一下
        // 还有一些其他参数
      }
    })

    // this.list = res.rows // 面试题列表数据
    return res
  }

  getList2(): Promise<PageData> {
    return http.request<PageData>({
      url: 'question/list',
      params: {
        questionBankType: 10, // 表示获取面试题
        type: this.typeId, // 获取哪个分类
        page: this.page, // 获取第几页
        pageSize: 10, // 每页获取几条数据
        sort: this.sort // 排序方式
        // 还有一些其他参数
      }
    })
  }

  // async aboutToAppear() {
  //   if (this.typeId) {
  //     this.getList()
  //   } // 获取列表数据


  // axios的不好  请求一下
  // 下载 => sync now => 使用    终端 ohpm i @ohos/axios
  // const res = await axios<null, AxiosResponse<CateResType, null>, null>({
  //   url: 'https://api-harmony-teach.itheima.net/hm/question/type'
  // })
  //
  // res.data // 后端返回的数据
  // res.data.message // 提示
  // res.data.data // 数组数据(关键数据)

  // ! 不爽的地方:
  // ! 1. 泛型很难受    很多泛型不需要写 强制写
  // ! 2. 数据点的好烦   res.data.message      res.data.data

  // const res = await http.request<QuestionType[]>({ url: 'question/type' })
  // res


  // axios拦截器
  // 请求拦截器
  // 响应拦截器

  // this.xx = res
  // this.xx = res.data.data
  // }


  // 希望组件被下拉时 能够独立维护这部分的逻辑
  async onRefresh() {
    this.page = 1
    const res = await this.getList2()

    // this.list = []
    this.list = res.rows // 直接清空覆盖

    this.isRefreshing = false

    if (this.list.length == res.total) {
      this.isFinished = true
    } else {
      this.isFinished = false
      this.page++ // 为触底做准备
    }


    // setTimeout(() => {
    //   // 更新数据
    //   this.list = []
    //   for (let i = 0; i < 10; i++) {
    //     this.list.push({} as QuestionItem)
    //   }
    //
    //   // 关闭下拉
    //   this.isRefreshing = false
    //   // 关闭isFinished
    //   this.isFinished = false
    //
    // }, 1000)
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
    const res = await this.getList2()

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

    // setTimeout(() => {
    //   // 数据要变多  push   模拟追加十份数据
    //   for (let i = 0; i < 10; i++) {
    //     this.list.push({} as QuestionItem)
    //   }
    //
    //   // 3 请求完成后关闭
    //   this.isLoading = false
    //
    //   if (this.list.length >= 50) {
    //     this.isFinished = true // 数据加载完毕
    //   }
    //
    // }, 1000)


  }

  build() {
    Column() {
      if (this.page == 1) {
        HcSkeleton()
      }
      Refresh({ refreshing: $$this.isRefreshing }) {
        // 虽然数据是模拟出来的  但是我们也想做出上拉加载 下拉刷新的效果
        // 1. 下拉刷新
        List() {
          ForEach(this.list, (item: QuestionItem) => {
            ListItem() {
              QuestionItemComp({
                item: item
              })
                .onClick(() => {
                  // router.pushUrl({
                  //   url: '/pages/QuestionPage'.slice(1)
                  // })
                  auth.checkAuth({
                    url: '/pages/QuestionPage'.slice(1),
                    params: {
                      item: item // item.id
                      // xx: 123
                      // yy: 456
                      // zz: 789
                    }
                  })
                })
            }
          })

          this.LoadMoreBuilder()
        }
        .onReachEnd(() => {
          // 触底触发
          // 4 判断(节流)
          // if (this.isLoading) {
          //   return
          // }
          //
          // 如果加载完成 也不能加载数据了
          // if (this.isFinished) {
          //   return
          // }

          if (this.isLoading || this.isFinished || this.isRefreshing) {
            return
          }

          this.isLoading = true // 1 打开开关


          // setTimeout(() => {
          this.onLoad()
          // }, 3000)
          // 2 请求


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
}