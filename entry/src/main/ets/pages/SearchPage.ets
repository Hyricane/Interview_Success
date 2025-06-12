import { router } from '@kit.ArkUI'
import { QuestionListComp } from '../commons/components'
import { history } from '../commons/utils/History'
import { SearchHistory } from '../views/Search/SearchHistory'

@Entry
@Component
struct SearchPage {
  @StorageProp('topHeight') topHeight: number = 0
  @State keyword: string = '' // 用户输入的关键字
  @State isSearch: boolean = false // 表示用户正在搜索...

  build() {
    Column() {
      Row({ space: 16 }) {
        // TextInput  与 Search  一样的姿势
        Search({ placeholder: '请输入试题关键字', value: this.keyword })
          .placeholderFont({ size: 14 })
          .height(32)
          .layoutWeight(1)
          .defaultFocus(true)
          .onSubmit((value) => {
            // 回车确认提交事件
            this.keyword = value

            if (value) {
              // 有值才开启搜索
              this.isSearch = true
              history.setItem(value)
            }
          })
          .onChange((value) => {
            // value改变事件
            this.keyword = value

            if (!value) {
              // 没值时  显示搜索历史
              this.isSearch = false
            }
          })
        Text('取消')
          .fontColor($r('app.color.black'))
          .fontSize(15)
          .fontWeight(500)
          .onClick(() => router.back())
      }
      .height(64)
      .padding({ left: 16, right: 16 })
      .border({ width: { bottom: 0.5 }, color: $r('app.color.common_gray_border') })

      Column() {
        if (this.isSearch) {
          // 如果用户正在搜索  显示试题列表组件
          // TODO 试题列表
          QuestionListComp({
            keyword: this.keyword
            // 1.需要将用户的输入传入组件中
            // 2.组件内部要接受
            // 3.组件内部用这个数据
          })
        } else {
          // 不在搜索 显示搜索历史
          SearchHistory({
            onSearch: keyword => {
              // TODO 进行搜索
            }
          })
        }
      }
      .layoutWeight(1)
    }
    .padding({ top: this.topHeight })
    .width('100%')
    .height('100%')
  }
}