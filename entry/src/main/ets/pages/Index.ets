import { HcSearchBox,HomePage,InterviewPage,ProjectPage,HcClockIn} from '../commons/components';
import { SetFullScreen } from '../commons/utils';
import { MinePage } from '../views/Mine/MinePage';

interface TabItem {
  icon: Resource;
  activeIcon: Resource;
  name: string;
}
@Entry
@Component
struct Index {
  // struct Index 数据
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
  @Builder
  TabBarBuilder(item: TabItem, index: number) {
    Column({ space: 5 }) {
      Image(this.activeIndex === index ? item.activeIcon : item.icon)
        .width(24)
        .aspectRatio(1)
      Text(item.name)
        .fontSize(12)
        .fontColor(this.activeIndex === index ? $r('app.color.black') : $r('app.color.common_gray_01'))
    }
  }
  @State activeIndex:number = 0
  @StorageProp('topHeight') tHeight: number = 0
  @StorageProp('bottomHeight') bHeight: number = 0
  aboutToAppear(): void {
    SetFullScreen.enableFullScreen()
  }

  build() {
    Column() {
      Tabs({ index: this.activeIndex }) {
        ForEach(this.tabList, (item: TabItem, i) => {
          TabContent() {
            if (this.activeIndex==0) {
              HomePage()
            }else if (this.activeIndex==1){
              ProjectPage()
            }else if (this.activeIndex==2){
              InterviewPage()
            }else if (this.activeIndex==3){
              MinePage()
            }
          }
          .tabBar(this.TabBarBuilder(item, i))
        })
      }
      .layoutWeight(1)
      .divider({ strokeWidth: 0.5, color: $r('app.color.common_gray_border') })
      .barPosition(BarPosition.End)
      .scrollable(false)
      .animationDuration(0)
      .onChange((index)=>{
        this.activeIndex = index
      })
    }
    .padding({top:this.tHeight,bottom:this.bHeight})
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.white'))
  }
}
