import {SetFullScreen } from '../commons/utils/FullScreen';
import { statusBar,Logger} from '../commons/utils';


@Entry
@Component
struct Index {
  @State message: string = '测试11';
  @StorageProp('topHeight') tHeight: number = 0
  @StorageProp('bottomHeight') bHeight: number = 0

  build() {
    Column() {
      Button('关闭沉浸式')
        .onClick(()=>{
          SetFullScreen.disableFullScreen()
        })
      Button('黑色状态栏')
        .onClick(()=>{
          statusBar.setDarkBar()
        })
      Button('白色状态栏')
        .onClick(()=>{
          statusBar.setLightBar()
        })
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
          SetFullScreen.enableFullScreen()
        })
    }
    .padding({top:this.tHeight,bottom:this.bHeight})
    .backgroundColor(Color.Pink)
    .height('100%')
    .width('100%')
  }
}