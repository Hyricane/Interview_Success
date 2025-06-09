import { HcNavBar, HcTag, HcLoadingDialog } from '../commons/components'
import { promptAction, router } from '@kit.ArkUI'
import { QuestionDetail, QuestionPageParams } from '../models'
import { http } from '../commons/utils/Http'
import { webview } from '@kit.ArkWeb'

@Entry
@Component
struct QuestionPage {
  @StorageProp('bottomHeight') bottomHeight: number = 0
  yy = new CustomDialogController({
    builder: HcLoadingDialog(), // 指定使用哪个组件
    // 自定义样式
    customStyle: true, // 默认情况下 他会给你一个容器写结构
    // alignment: DialogAlignment.Center
  })

  @Builder
  TitleBuilder(text: string) {
    Row() {
      Text()
        .width(2)
        .height(12)
        .backgroundColor($r('app.color.black'))
        .margin({ right: 13 })
      Text(text)
        .fontWeight(700)
    }
    .width('100%')
    .padding({ top: 10 })
    .height(32)
  }

  @Builder
  MenuBuilder() {
    // 想会
    // 菜单
    Menu() {
      // 菜单项
      MenuItem({ content: this.item.likeFlag == 1 ? '取消点赞' : '点赞' })
      MenuItem({ content: this.item.collectFlag == 1 ? '取消收藏' : '收藏' })
      MenuItem({ content: '点我反馈' })
      MenuItem({ content: '试题分享' })
    }
    .width(108)
  }

  @State item: QuestionDetail = {} as QuestionDetail
  @State list: QuestionDetail[] = []
  controller = new webview.WebviewController()

  async aboutToAppear() {
    // AlertDialog.show({ message: JSON.stringify(router.getParams(), null, 4) })
    // 页面跳转传参
    const params = router.getParams() as QuestionPageParams
    if (params) {
      this.item = params.item // 存储传递的参数
      // 请求后端 这个试题的详情

      // 额外收到一个list
      this.list = params.list as QuestionDetail[]


      this.yy.open() // 打开组件
      this.item = await http.request<QuestionDetail>({ url: `question/${this.item.id}` })
      this.yy.close() // 关闭组件
      // this.item.answer  其中含有前端格式的信息
      // AlertDialog.show({ message: JSON.stringify(this.item, null, 4) })
    }
  }

  async goNextOrPrev(num: -1 | 1) {
    const index = this.list.findIndex(item => item.id == this.item.id)
    this.list[index] = this.item // 进入的那个题目也存到list中

    const targetIndex = index + num // 目标数据的下标
    // 0 => -1        length-1 => length
    if (targetIndex < 0 || targetIndex > this.list.length - 1) {
      promptAction.showToast({ message: '到头了' })
      return
    }
    const targetItem = this.list[targetIndex] // 目标数据
    // AlertDialog.show({ message: JSON.stringify(targetItem, null, 4) })

    // 请求最全的数据  存item   页面绑定item
    if (targetItem.answer) {
      // 直接使用targetItem渲染
      this.item = targetItem
    } else {
      this.yy.open()
      this.item = await http.request<QuestionDetail>({ url: `question/${targetItem.id}` })
      this.list[targetIndex] = this.item // 完整的数据存到list  希望以后如果数据完整 就不请求后端
      this.yy.close()
    }


    // 利用控制器重新加载question.html页面  重新触发PageEnd事件
    this.controller.loadUrl($rawfile('question.html'))
    // AlertDialog.show({ message: JSON.stringify(this.item, null, 4) })
  }

  build() {
    Column() {
      HcNavBar({ title: '试题详情', showRightIcon: false })
      // 题目
      this.TitleBuilder('题目：')
      Text(this.item.stem)
        .width('100%')
        .padding(16)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Row({ space: 12 }) {
        ForEach(this.item.stage, (item: string) => {
          HcTag({ text: item, color: '#ff6600' })
        })

        Blank()
        Image($r("app.media.ic_home_more"))
          .width(20)
          .aspectRatio(1)
          .bindMenu(this.MenuBuilder())
      }
      .width('100%')
      .padding({ bottom: 16, left: 16, right: 16 })

      Divider()
        .strokeWidth(8)
        .color($r('app.color.common_gray_bg'))
      // 内容
      this.TitleBuilder('答案：')
      // 富文本 RichText  解析前端格式
      // if (this.item.answer) {
      //   // 确实可以解析前端格式  但是展示的效果很差
      //   // 解决办法 => Web组件
      //   RichText(this.item.answer)
      //     .layoutWeight(1)
      //     .padding(16)
      // }

      // 封装出来的加载弹窗组件:
      // 使用方法1. 配合一个状态变量this.loading  显示隐藏组件本身
      // 使用方法2. 利用控制器 打开 关闭这个组件   this.c.open()   this.c.close()

      // web组件的创建前提是 有答案
      if (this.item.answer) {
        Web({
          // 要用writeHTML方法画UI结构
          src: $rawfile('question.html'), // 用项目中的rawfile文件夹中的question.html展示
          controller: this.controller
        })
          .layoutWeight(1)
          .width('100%')
          .onPageEnd(() => {
            // 页面加载完成后 => 可以使用writeHTML方法
            // ' \' \' '  转义  就是普通字符串的意思
            this.controller.runJavaScript(`writeHtml(\`${this.item.answer}\`)`) // 他可以直接执行网页中的js方法
          })
      }


      // ! 布局 考虑到整体功能
      Row({ space: 80 }) {
        Row() {
          Image($r('sys.media.ohos_ic_public_arrow_left'))
            .width(20)
            .aspectRatio(1)
            .fillColor($r('app.color.common_gray_01'))
          Text(' 上一题')
            .fontColor($r('app.color.common_gray_01'))
        }
        .onClick(() => {
          // 知道当前的item   list
          // 下一个item
          this.goNextOrPrev(-1)

          // {name: 'ls'}   找下标  1    下标++    2
          // [ {name: 'zs'}, {name: 'ls'}, {name: 'ww'} ]
        })

        Row() {
          Text('下一题 ')
            .fontColor($r('app.color.common_gray_03'))

          Image($r('sys.media.ohos_ic_public_arrow_right'))
            .width(20)
            .aspectRatio(1)
            .fillColor($r('app.color.common_gray_03'))
        }
        .onClick(() => {
          // 知道当前的item   list
          // 下一个item
          this.goNextOrPrev(1)

          // {name: 'ls'}   找下标  1    下标++    2
          // [ {name: 'zs'}, {name: 'ls'}, {name: 'ww'} ]
        })
      }
      .height(44)
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .padding({ bottom: this.bottomHeight })
  }
}