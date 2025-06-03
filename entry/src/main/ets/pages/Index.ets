import { enableFullScreen } from '../commons/utils/enableFullScreen';
import { Logger } from '../commons/utils/Logger';

@Entry
@Component
struct Index {
  @State message: string = '测试11';
  @StorageProp('topHeight') tHeight: number = 0
  @StorageProp('bottomHeight') bHeight: number = 0

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          this.message = 'Welcome';
          new enableFullScreen().enableFullScreen()
        })
    }
    .padding({top:this.tHeight,bottom:this.bHeight})
    .backgroundColor(Color.Pink)
    .height('100%')
    .width('100%')
  }
}