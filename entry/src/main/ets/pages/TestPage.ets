import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';
import { HcNavBar } from '../commons/components';

@Entry
@Component
struct TestPage {
  @State src: string = '';
  @State title: string = '';
  @StorageProp('bottomHeight') bottomHeight: number = 0

  aboutToAppear(): void {
    const obj = router.getParams() as Record<string, string>
    this.src = obj.src
    this.title = obj.title
  }

  build() {
    Column() {
      // 一个套壳京东做完了
      // => 实际使用的是app中套的网页
      // 体验差一些 没有原生app来的体验好 有些原生功能做不了
      HcNavBar({ title: this.title, showRightIcon: false }) // 非侵入式
      Web({
        src: this.src, // 网页地址
        // src: 'https://in.m.jd.com/help/app/private_policy.html', // 网页地址
        // src: 'https://www.jd.com', // 网页地址
        controller: new webview.WebviewController() // 控制器
      })
        .layoutWeight(1)
        .width('100%')
    }
    .height('100%')
    .width('100%')
    .padding({ bottom: this.bottomHeight })
  }
}