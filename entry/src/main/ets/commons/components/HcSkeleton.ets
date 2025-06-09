// 祛魅   骨架屏(一个有宽高的灰色盒子组成了一块结构   呼吸效果)

@Component
export struct HcSkeletonItem {
  @Prop widthValue: number = 100
  @State op: number = 1

  build() {
    Text()
      .width(this.widthValue)
      .height(30)
      .backgroundColor('#ccc')
      .opacity(this.op)
      .onAppear(() => {
        animateTo({
          duration: 1000,
          iterations: -1,
          // 1=>0.3有动画   1=>0.3有动画
          playMode: PlayMode.Alternate
        }, () => {
          this.op = 0.5
        })
      })
  }
}

// 产品经理   管理app的经理
@Component
export struct HcSkeleton {
  build() {
    Column() {
      // Row({ space: 5 }) {
      //   ForEach(new Array(5).fill(6), () => {
      //     HcSkeletonItem({ widthValue: 60 })
      //   })
      // }
      // .width('100%')
      // .padding({ left: 15 })

      ForEach(new Array(6).fill(6), () => {
        Column({ space: 5 }) {
          Row({ space: 5 }) {
            HcSkeletonItem({ widthValue: 30 })
            HcSkeletonItem({ widthValue: 250 })
          }
          .width('100%')

          Row({ space: 5 }) {
            HcSkeletonItem({ widthValue: 60 })
            HcSkeletonItem({ widthValue: 60 })
            HcSkeletonItem({ widthValue: 60 })
          }
          .width('100%')
        }
        .padding({ left: 15, right: 15, top: 15 })
        .width('100%')
      })
    }
  }
}