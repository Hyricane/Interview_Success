import { HcNavBar } from '../commons/components'
import { promptAction, router } from '@kit.ArkUI'
import { auth, http } from '../commons/utils'
import { User } from '../models'
import { LOGIN_EVENT } from '../commons/constants'
import { emitter } from '@kit.BasicServicesKit'
import { tracking } from '../commons/utils/Tracking'


@Entry
@Component
struct LoginPage {
  @StorageProp('topHeight')
  topHeight: number = 0
  @State
  mobile: string = 'hmheima'
  @State
  code: string = 'Hmheima%123'
  @State
  isAgree: boolean = false
  // 登录请求的过程
  @State
  loading: boolean = false

  // aboutToAppear(): void {
  //   let obj = router.getParams() as Record<string, string>
  //
  //   AlertDialog.show({ message: '我一会要去' + obj.return_url })
  //
  // }

  async login() {
    if (this.loading) {
      return
    }
    if (!this.mobile) {
      return promptAction.showToast({ message: '请输入用户名' })
    }
    if (!this.code) {
      return promptAction.showToast({ message: '请输入密码' })
    }
    if (!this.isAgree) {
      return promptAction.showToast({ message: '请勾选已阅读并同意' })
    }

    /*
     * 正常情况下
     * 对于一个请求来说
     * 成功 then   await后面的代码
     * 失败 catch  catch里面的代码
     *
     * 实际开发 后端一般会在请求成功后返回一个成功的promise
     * 实际开发 后端一般会在请求失败后返回一个成功的promise
     *
     * 后端的视角
     * 一个请求只要是正常发送了
     * 无论拿到数据了  还是没拿到数据  都认为这次请求是成功的
     * 额外给了你个东西
     *
     * 打个比方:
     * 张三 有一天找 李四  借钱
     * 李四: 我考虑好了  但是不借你
     * 李四: 我考虑好了  借你
     *
     *
     * 矛盾: 所有的请求成功  并不意味着 拿到数据了(code  10000 拿到了)
     * 遇到一个处理一次   一起在拦截器处理
     *
     *
     * */
    try {
      this.loading = true
      // 发请求
      const res = await http.request<User>({
        url: 'login',
        method: 'post',
        data: {
          username: this.mobile,
          password: this.code
        }
      })
      this.loading = false
      // AlertDialog.show({
      //   message: '登录成功:' + JSON.stringify(res, null, 4)
      // })
      promptAction.showToast({ message: '登录成功' })
      // AppStorage.setOrCreate<User>('user', res)
      auth.setUser(res)
      emitter.emit(LOGIN_EVENT) // 通知首页更新
      //主动上报
      tracking.report(true)
      // 不一定是回去 也有可能去一个指定的页面
      let obj = router.getParams() as Record<string, string> || {}
      // obj.return_url ? router.pushUrl({ url: obj.return_url }) : router.back()

      if (obj.return_url) {
        // 有回跳地址 去回跳页面
        router.replaceUrl({ url: obj.return_url, params: obj }) // a b c      a c
      } else {
        // 正常返回
        router.back()
      }

    } catch (err) {
      // AlertDialog.show({ message: '登录失败:' + JSON.stringify(err, null, 4) })
      promptAction.showToast({ message: err.message })
      this.loading = false
    }


  }

  build() {
    Column() {
      HcNavBar({ showRightIcon: false })

      Column() {
        Image($r('app.media.icon'))
          .width(120)
          .aspectRatio(1)
        Text('面试通')
          .fontSize(28)
          .margin({ bottom: 15 })
        Text('搞定企业面试真题，就用面试通')
          .fontSize(14)
          .fontColor($r('app.color.common_gray_01'))
      }
      .padding(16)

      Column({ space: 15 }) {
        TextInput({ placeholder: '请输入用户名', text: $$this.mobile })
          .customStyle()
        TextInput({ placeholder: '请输入密码', text: $$this.code })
          .type(InputType.Password)
          .showPasswordIcon(false)
          .customStyle()
        Row() {
          Checkbox()
            .shape(CheckBoxShape.ROUNDED_SQUARE)
            .selectedColor('#fa711d')
            .size({ width: 14, height: 14 })
            .select(this.isAgree)
            .onChange((val) => {
              this.isAgree = val
            })
          Text('已阅读并同意')
            .fontSize(14)
            .fontColor($r('app.color.common_gray_01'))
            .padding({ right: 4 })
          Text('用户协议')
            .fontSize(14)
            .padding({ right: 4 })
            .onClick(() => {
              router.pushUrl({
                url: '/pages/TestPage'.slice(1),
                params: {
                  src: 'http://110.41.143.89/user',
                  title: '用户协议'
                }
              })
            })
          Text('和')
            .fontSize(14)
            .fontColor($r('app.color.common_gray_01'))
            .padding({ right: 4 })
          Text('隐私政策')
            .fontSize(14)
            .onClick(() => {
              router.pushUrl({
                url: '/pages/TestPage'.slice(1),
                params: {
                  src: 'http://110.41.143.89/privacy',
                  title: '隐私政策'
                }
              })
            })
        }
        .width('100%')

        Button({ type: ButtonType.Normal }) {
          Row() {
            if (this.loading) {
              LoadingProgress()
                .color($r('app.color.white'))
                .width(24)
                .height(24)
                .margin({ right: 10 })
            }
            Text('立即登录')
              .fontColor($r('app.color.white'))
          }
        }
        .width('100%')
        .backgroundColor('none')
        .borderRadius(4)
        .height(44)
        .linearGradient({
          direction: GradientDirection.Right,
          colors: [['#fc9c1c', 0], ['#fa711d', 1]]
        })
        .stateEffect(false)
        .onClick(() => {
          // TODO
          this.login()
        })
      }
      .padding({ left: 36, right: 36, top: 30 })


      Column() {
        Text('其他登录方式')
          .fontSize(14)
          .fontColor($r('app.color.common_gray_01'))
      }
      .padding({ top: 70, bottom: 100 })

    }
    .width('100%')
    .height('100%')
  }
}

@Extend(TextInput)
function customStyle() {
  .placeholderColor('#C3C3C5')
  .caretColor('#fa711d')
  .height(44)
  .borderRadius(0)
  .backgroundColor($r('app.color.white'))
  .border({ width: { bottom: 0.5 }, color: $r('app.color.common_gray_border') })
}