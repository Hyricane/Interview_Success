@Component
export struct HcSkeletonItem {
  @Prop widthValue: string|number = 100
  build() {
    Text()
      .width(this.widthValue)
      .height(30)
      .backgroundColor('#ccc')
  }
}

@Component
export struct HcSkeleton {
  @State opacityValue: number = 1

  @Builder
  defaultBuilder() {
  }

  @BuilderParam
  default: () => void = this.defaultBuilder

  build() {
    Row({ space: 15 }) {
      this.default()
    }
    .opacity(this.opacityValue)
    .animation({
      duration:1000,
      iterations:-1,
      playMode:PlayMode.Alternate,
    })
    .onAppear(() => {
      this.opacityValue = 0.5
    })
  }
}