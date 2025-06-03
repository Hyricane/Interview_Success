import { HomeCategory } from "../../views/HomeCategory"
import { QuestionItemComp } from "./QuestionItemComp"

@Component
export struct HomePage {
  swiperItemList:ResourceStr[]=[
    $r('app.media.banner_pj'),
    $r('app.media.banner_ai'),
    $r('app.media.banner_qa')
  ]
  build() {
    Column(){
      this.swiperBuilder(this.swiperItemList)
      Column(){
        HomeCategory()
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor($r('app.color.white'))
    }
  }
  @Builder swiperBuilder(siwperItemList:ResourceStr[]){
    Swiper(){
      ForEach(siwperItemList,(item:ResourceStr)=>{
        Row(){
          Image(item)
            .width('100%')
            .aspectRatio(2.65)
            .objectFit(ImageFit.Fill)
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
      })
    }
    .margin({ bottom: 16,top:16})
    .autoPlay(true)
    .indicator(DotIndicator.dot()
      .bottom(4)
      .itemHeight(4)
      .selectedItemHeight(4)
      .selectedColor($r('app.color.white')))
  }
}