import { auth, fullScreen } from '../commons/utils';
import { HomePage } from '../views/Home/HomePage';
import { InterviewPage } from '../views/Interview/InterviewPage';
import { MinePage } from '../views/Mine/MinePage';
import { ProjectPage } from '../views/Project/ProjectPage';

interface TabItem {
  icon: Resource;
  activeIcon: Resource;
  name: string;
}

// 应用启动时  初始化数据user
auth.initUser()

@Entry
@Component
struct Index {
  tabList: TabItem[] = [
    {
      icon: $r('app.media.tabbar_home'),
      activeIcon: $r('app.media.tabbar_home_fill'),
      name: '首页'
    },
    {
      icon: $r('app.media.tabbar_project'),
      activeIcon: $r('app.media.tabbar_project_fill'),
      name: '项目'
    },
    {
      icon: $r('app.media.tabbar_interview'),
      activeIcon: $r('app.media.tabbar_interview_fill'),
      name: '面经'
    },
    {
      icon: $r('app.media.tabbar_mine'),
      activeIcon: $r('app.media.tabbar_mine_fill'),
      name: '我的'
    }
  ]
  @State activeIndex: number = 0
  // 获取安全区高度
  @StorageProp('bottomHeight') bottomHeight: number = 0

  aboutToAppear(): void {
    fullScreen.enable() // 全屏 + 获取规避区高度存appstorage
  }

  @Builder
  TabBarBuilder(item: TabItem, index: number) {
    Column({ space: 5 }) {
      Image(this.activeIndex === index ? item.activeIcon : item.icon)
        .width(24)
        .aspectRatio(1)
      Text(item.name)
        .fontSize(12)
        .fontColor(this.activeIndex == index ? $r('app.color.black') : $r('app.color.common_gray_01'))
    }
  }

  build() {
    Column() {
      Tabs({
        index: this.activeIndex// 指定默认展示哪个tab
      }) {
        ForEach(this.tabList, (item: TabItem, index: number) => {
          TabContent() {
            if (index == 0) {
              HomePage()
            } else if (index == 1) {
              ProjectPage()
            } else if (index == 2) {
              InterviewPage()
            } else {
              MinePage()
            }
          }.tabBar(this.TabBarBuilder(item, index))

        })


      }
      .scrollable(false)
      .animationDuration(0)
      .onChange((index) => {
        this.activeIndex = index
      })
      .divider({ strokeWidth: 0.5, color: $r('app.color.common_gray_border') })
      .barPosition(BarPosition.End)

      // .onTabBarClick((index) => {
      //   this.activeIndex = index
      // })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.white')) // 颜色资源
    .padding({ bottom: this.bottomHeight })
  }
}

// import { window } from '@kit.ArkUI';
// import { fullScreen, statusBar } from '../commons/utils';
//
// // import {  } from '../commons/utils';
//
// @Entry
// @Component
// struct Index {
//   @State message: string = 'Hello World';
//   @StorageProp('topHeight') xx: number = 0
//   @StorageProp('bottomHeight') yy: number = 0
//
//   build() {
//     // 非沉浸式: 手机app的布局区域未充满整个手机屏
//     // 沉浸式: 手机app的布局区域充满整个手机屏
//     // 非侵入性沉浸式
//     Column() {
//       Text(this.message)
//         .fontColor($r('app.color.jd_red'))
//         .fontSize($r('app.float.page_text_font_size'))
//         .fontWeight(FontWeight.Bold)
//         .onClick(async () => {
//           fullScreen.enable()
//         })
//
//       Button('关')
//         .onClick(() => {
//           fullScreen.disable()
//         })
//
//       Button('dark')
//         .onClick(() => {
//           statusBar.setDarkBar()
//         })
//       Button('light')
//         .onClick(() => {
//           statusBar.setLightBar()
//         })
//       Button('baby blue')
//         .onClick(() => {
//           statusBar.setBar('#88ddff')
//         })
//
//       List() {
//         ForEach(Array.from({ length: 100 }), () => {
//           ListItem() {
//             Text('111')
//           }
//         })
//       }
//       .width('100%')
//       .layoutWeight(1)
//       .border({
//         width: 1
//       })
//
//     }
//     .height('100%')
//     .width('100%')
//     .backgroundColor(Color.Pink)
//     // 获取当前设备状态栏的高度
//     .padding({ top: this.xx, bottom: this.yy })
//   }
// }