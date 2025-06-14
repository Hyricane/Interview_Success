import { HcClockIn } from '../../commons/components'
import { promptAction, router } from '@kit.ArkUI'
import { FormatTime, statusBar, UserInfoKey } from '../../commons/utils'
import { User } from '../../models'

interface Nav {
  icon: ResourceStr
  name: string
  onClick?: () => void
  other?: string
}

interface Tool {
  icon: ResourceStr
  name: string
  value?: string
  onClick?: () => void
}

@Component
export struct MinePage {
  @StorageLink(UserInfoKey) user: User = {} as User
  @StorageProp('topHeight')
  topHeight: number = 0

  @Builder
  navBuilder(nav: Nav) {
    GridCol() {
      Column() {
        Image(nav.icon)
          .width(30)
          .aspectRatio(1)
          .margin({ bottom: 10 })
        Text(nav.name)
          .fontSize(14)
          .fontColor($r('app.color.common_gray_03'))
          .margin({ bottom: 4 })
        if (nav.other) {
          Row() {
            Text(nav.other)
              .fontSize(12)
              .fontColor($r('app.color.common_gray_01'))
            Image($r('sys.media.ohos_ic_public_arrow_right'))
              .width(12)
              .aspectRatio(1)
              .fillColor($r('app.color.common_gray_01'))
          }
        }
      }
      .onClick(() => {
        // 逻辑或的短路
        // 逻辑短路    逻辑与  全真才真
        nav.onClick && nav.onClick()
      })
    }
  }

  @Builder
  toolsBuilder(tool: Tool) {
    Row() {
      Image(tool.icon)
        .width(16)
        .aspectRatio(1)
        .margin({ right: 12 })
      Text(tool.name)
        .fontSize(14)
      Blank()
      if (tool.value) {
        Text(tool.value)
          .fontSize(12)
          .fontColor($r('app.color.common_gray_01'))
      }
      Image($r('sys.media.ohos_ic_public_arrow_right'))
        .width(16)
        .aspectRatio(1)
        .fillColor($r('app.color.common_gray_01'))
    }
    .height(50)
    .width('100%')
    .padding({ left: 16, right: 10 })
    .onClick(() => {
      // if   逻辑短路是if的进阶版本
      tool.onClick && tool.onClick()
    })
  }

  build() {
    Column({ space: 16 }) {
      Row({ space: 12 }) {
        // 前面真 不走后面
        // 前面假  走后面
        // ! 逻辑或 短路 =>  给默认值
        // 前面真 走后面
        // 前面假 不走后面
        // ! 逻辑与 短路 => 加if判断
        Image(this.user.avatar || $r('app.media.ic_mine_avatar'))
          .alt($r('app.media.ic_mine_avatar'))
          .width(55)
          .aspectRatio(1)
          .borderRadius(55)
        // 是否登录 token是用户信息的重要标识
        if (this.user.token) {
          Column({ space: 4 }) {
            Text(this.user.nickName || this.user.username)
              .fontSize(18)
              .fontWeight(500)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
            Row({ space: 4 }) {
              Text('编辑信息')
                .fontSize(12)
                .fontColor($r('app.color.common_gray_01'))
              Image($r('app.media.ic_mine_edit'))
                .width(12)
                .aspectRatio(1)
                .fillColor($r('app.color.common_gray_01'))
            }
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)
        } else {
          Text('立即登录')
            .fontSize(18)
            .fontWeight(500)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)
            .onClick(() => {
              router.pushUrl({ url: 'pages/LoginPage' })
            })
        }

        HcClockIn({ clockInCount: this.user.clockinNumbers })
      }
      .width('100%')
      .height(100)
      .margin({ top: this.topHeight })

      GridRow({ columns: 4 }) {
        // GridCol(){}
        this.navBuilder({
          icon: $r('app.media.ic_mine_history'),
          name: '历史记录',
          onClick: () => {
            // TODO
          }
        })
        this.navBuilder({
          icon: $r('app.media.ic_mine_collect'),
          name: '我的收藏',
          onClick: () => {
            // TODO
          }
        })
        this.navBuilder({
          icon: $r('app.media.ic_mine_like'),
          name: '我的点赞',
          onClick: () => {
            // TODO
          }
        })
        this.navBuilder({
          icon: $r('app.media.ic_mine_study'),
          name: '累计学时',
          other: FormatTime.getDHM(this.user.totalTime), // 分钟 小时 天
          onClick: () => {
            // TODO
            router.pushUrl({
              url:'pages/StudyTimePage'
            })
          }
        })
      }
      .backgroundColor($r('app.color.white'))
      .padding(16)
      .borderRadius(8)


      Column() {
        this.toolsBuilder({
          icon: $r('app.media.ic_mine_notes'),
          name: '开发常用词',
          onClick: () => {
            // TODO
          },
          value: '哈哈'
        })
        this.toolsBuilder({ icon: $r('app.media.ic_mine_ai'), name: '面通AI' })
        this.toolsBuilder({ icon: $r('app.media.ic_mine_invite'), name: '推荐分享' })
        this.toolsBuilder({ icon: $r('app.media.ic_mine_file'), name: '意见反馈' })
        this.toolsBuilder({ icon: $r('app.media.ic_mine_info'), name: '关于我们' })
        this.toolsBuilder({
          icon: $r('app.media.ic_mine_setting'), name: '设置', onClick: () => {
            // TODO
          }
        })
      }
      .backgroundColor($r('app.color.white'))
      .borderRadius(8)


      Column() {
        Button('点击token过期')
          .onClick(() => {
            this.user.token = 'hhhh'
          })
      }

    }
    .padding(16)
    .backgroundColor($r('app.color.common_gray_bg'))
    .linearGradient({
      colors: [['#FFB071', 0], [$r('app.color.common_gray_bg'), 0.3], [$r('app.color.common_gray_bg'), 1]]
    })
    .width('100%')
    .height('100%')
    // ! 可视区域变化事件 => 如果组件的可见部分变化了 就会触发
    // 组件的显示隐藏状态
    .onVisibleAreaChange([0, 1], (isExpanding) => {
      // 组件可见面积与组件面积 趋近0 会触发这个回调函数
      // 组件可见面积与组件面积 趋近1 会触发这个回调函数

      // isExpanding 表示比值在变大 true 还是变小 false
      // 粗略的理解成出现和消失
      // promptAction.showToast({
      //   message: '' + isExpanding
      // })
      isExpanding ? statusBar.setLightBar() : statusBar.setDarkBar()
    })

    // // 组件的创建
    // .onAppear(() => {
    //   statusBar.setLightBar()
    // })
    // // 组件的销毁
    // .onDisAppear(() => {
    //   statusBar.setDarkBar()
    // })
  }
}