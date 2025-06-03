import { window } from '@kit.ArkUI'
import { logger } from './Logger'

export class FullScreen{
  async enableFullScreen(){
    try {
      //传入上下文 定义在entryAbility中
      const ctx = AppStorage.get<Context>('context')
      if (ctx){
        const winObj = await window.getLastWindow(ctx) //获得上层窗口对象
        //打开全屏
        winObj.setWindowLayoutFullScreen(true)//返回promise对象,异步操作
        //获取规避区域系统区域高度
        const statusBar = winObj.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
        // 存在AppStroage中方便页面使用
        AppStorage.setOrCreate('topHeight',px2vp(statusBar.topRect.height))
        //获取底部导航栏高度
        const naviBar = winObj.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
        AppStorage.setOrCreate('bottomHeight',px2vp(naviBar.bottomRect.height))
      }
    }catch (err) {
      logger.error('FullScreen enable error',JSON.stringify(err))
    }
  }

  async disableFullScreen(){
    try {
      //传入上下文 定义在entryAbility中
      const ctx = AppStorage.get<Context>('context')
      if (ctx){
        const winObj = await window.getLastWindow(ctx) //获得上层窗口对象
        //关闭全屏
        winObj.setWindowLayoutFullScreen(false)//返回promise对象,异步操作
        // //获取规避区域系统区域高度
        // const statusBar = winObj.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
        // // 存在AppStroage中方便页面使用
        // AppStorage.setOrCreate('topHeight',px2vp(statusBar.topRect.height))
        // //获取底部导航栏高度
        // const naviBar = winObj.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
        // AppStorage.setOrCreate('bottomHeight',px2vp(naviBar.bottomRect.height))
      }
    }catch (err) {
      logger.error('FullScreen enable error',JSON.stringify(err))
    }
  }
}

export let SetFullScreen = new FullScreen()