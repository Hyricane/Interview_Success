import { HcSearchBox, HcClockIn, HcSkeleton } from "../../commons/components"
import { HomeCategory } from "./HomeCategory"

@Component
export struct HomePage {
  @StorageProp('topHeight') topHeight: number = 0
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

  build() {
    Column() {
      Row({ space: 16 }) {
        Image($r('app.media.ic_home_scan'))
          .width(24)
          .aspectRatio(1)
        HcSearchBox({
          layoutWeightValue: 1,
        })
        HcClockIn({
          clockInCount: 9
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
}