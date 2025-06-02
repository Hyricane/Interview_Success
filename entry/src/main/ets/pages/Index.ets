import { Logger } from '../commons/utils/Logger';

@Entry
@Component
struct Index {
  @State message: string = '测试11';

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
          let log = new Logger(0x0001,'测试','%{public}s %{public}s')
          log.debug('测试','1')
        })
    }
    .height('100%')
    .width('100%')
  }
}