import { window } from "@kit.ArkUI"
import { logger } from "./Logger"

// 获取当前应用内最上层的子窗口
// const xx = await window.getLastWindow()

// 设置主窗口或子窗口的布局是否为沉浸式布局
// xx.setWindowLayoutFullScreen

// 获取当前应用窗口内容规避的区域
// xx.getWindowAvoidArea

// 设置状态栏的文字颜色
// xx.setWindowSystemBarProperties

export class FullScreen {
  // 启动全屏
  async enable() {
    try {
      const ctx = AppStorage.get<Context>('context')
      // 空安全
      if (ctx) {
        const winObj = await window.getLastWindow(ctx) // 上层窗口对象

        // 打开全屏
        winObj.setWindowLayoutFullScreen(true) // 异步操作
        // logger.info('FullScreen封装', '完成')

        // 获取规避区域的高度
        const statusBar = winObj.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
        // appstorage中存一份 上规避区高度  下规避区高度
        AppStorage.setOrCreate('topHeight', px2vp(statusBar.topRect.height))

        const naviBar = winObj.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
        AppStorage.setOrCreate('bottomHeight', px2vp(naviBar.bottomRect.height))

      }
    } catch (err) {
      logger.error('FullScreen enable error', JSON.stringify(err))
    }

  }

  // 退出全屏
  async disable() {
    try {
      const ctx = AppStorage.get<Context>('context')
      // 空安全
      if (ctx) {
        const winObj = await window.getLastWindow(ctx) // 上层窗口对象

        // 打开全屏
        winObj.setWindowLayoutFullScreen(false) // 异步操作
        // logger.info('FullScreen封装', '完成')


        AppStorage.setOrCreate('topHeight', 0)

        AppStorage.setOrCreate('bottomHeight', 0)

      }
    } catch (err) {
      logger.error('FullScreen enable error', JSON.stringify(err))
    }
  }
}

export const fullScreen = new FullScreen()

// obj.enable() // 开启全屏