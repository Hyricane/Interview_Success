import { HcSearchBox, HcClockIn, HcSkeleton } from "../../commons/components"
import { HomeCategory } from "./HomeCategory"
import { scanBarcode } from "@kit.ScanKit"
import { promptAction, router } from "@kit.ArkUI"
import { http } from "../../commons/utils/Http"
import { QuestionDetail, User } from "../../models"
import { tracking } from "../../commons/utils/Tracking"
import { auth, clockIn, UserInfoKey } from "../../commons/utils"

@Component
export struct HomePage {
  @StorageProp('topHeight') topHeight: number = 0
  @StorageProp(UserInfoKey) user: User = {} as User
  swiperList: ResourceStr[] = [
    $r('app.media.banner_ai'),
    $r('app.media.banner_pj'),
    $r('app.media.banner_qa')
  ]

  @Builder
  SwiperItemBuilder(src: ResourceStr) {
    Row() {
      Image(src)
        .width('100%')
        .aspectRatio(2.65)
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
  }

  //主动上报
  aboutToAppear(): void {
    tracking.report(true)
  }

  build() {
    Column() {
      Row({ space: 16 }) {
        Image($r('app.media.ic_home_scan'))
          .width(24)
          .aspectRatio(1)
          .onClick(()=>{
            auth.checkAuth2(()=>{
              this.scanToDetail()
            })
          })
        HcSearchBox({
          layoutWeightValue: 1,
        })
          .onClick(() => {
            // 进入搜索页面必须先登录  =>>  产品经理(想的功能被市场认可)
            router.pushUrl({
              url: '/pages/SearchPage'.slice(1)
            })
          })
        HcClockIn({
          clockInCount: this.user.clockinNumbers
        })
          .onClick(()=>{
            clockIn.request()
          })
      }
      .padding({ left: 16, right: 16 })
      .height(64)
      .width('100%')

      Swiper() {
        ForEach(this.swiperList, (item: ResourceStr) => {
          this.SwiperItemBuilder(item)
        })
      }
      .margin({ bottom: 16 })
      .autoPlay(true)
      .loop(true)
      .indicator(
        Indicator.dot()
          .bottom(4)
          .itemHeight(4)
          .selectedItemHeight(4)
          .selectedColor($r('app.color.white'))
      )

      // HcSkeleton()
      // 测试
      // Column({ space: 5 }) {
      //   Row({ space: 5 }) {
      //     HcSkeletonItem({ widthValue: 30 })
      //     HcSkeletonItem({ widthValue: 250 })
      //   }
      //   .width('100%')
      //
      //   Row({ space: 5 }) {
      //     HcSkeletonItem({ widthValue: 60 })
      //     HcSkeletonItem({ widthValue: 60 })
      //     HcSkeletonItem({ widthValue: 60 })
      //   }
      //   .width('100%')
      // }
      // .padding(15)
      // .width('100%')

      Column() {
        // 考虑到这部分代码较复杂  维护不方便  抽取到views
        HomeCategory()
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor($r('app.color.white'))
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.common_gray_bg'))
    .padding({ top: this.topHeight })
  }
  private async scanToDetail() {
    // 调用前需要使用canIUse():boolean判断当前设备是否有扫码能力
    if (canIUse('SystemCapability.Multimedia.Scan.ScanBarcode')) {
      const res = await scanBarcode.startScanForResult(getContext())
      //结果.originalValue即为二维码真实数据
      if (res.originalValue) {//若数据存在
        try {
          const item = await http.request<QuestionDetail>({//发送请求
            url: `question/${res.originalValue}`
          })
          router.pushUrl({
            url: '/pages/QuestionPage'.slice(1),
            params: {
              item,
              list: [item]//数组中只有该项数据
            }
          })
        } catch (e) {
          promptAction.showToast({ message: '未找到该题' })
        }
      }
    }
  }
}