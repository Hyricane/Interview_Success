import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { logger } from '../commons/utils';

// import {  } from '../commons/utils';

const DOMAIN = 0x0000;

// logger.info('money', money.toString())

/*
 * hilog 比 console 更专业
 * hilog.warn(参数1, 参数2, 参数3, ....) // 打印一次警告
 * 参数1: 日志对应的领域标识，范围是0x0~0xFFFF
 *          业务领域     0x0-0xFFFF    0x1234代表面试通业务
 *
 * 参数2: 指定日志标识，可以为任意字符串，建议用于标识调用所在的类或者业务行为
 *          标识(给个名字)     "面试通"
 * 参数3: 格式字符串，用于日志的格式化输出。     模板字符串`大家好我是${xx}我今年${yy}`
 *          %{public}s 字符串 %{public}d 数字
 *            public 公开  可见
 *            private 自私  不可见
 *            s  string   字符串
 *            d  digit    数字
 *
 *
 * hilog.warn(0x0001, "testTag", "%{public}s World %{private}d", "hello", 3);
 * "hello World "
 * */


// console.log('你好', 18, true)
//
// function fn(a: string, b: number, c: boolean) {
//   hilog.info(0x0001, 'JJJ', '%{public}s, %{public}d, %{public}s', a , b, c)
// }

// class Student extends Person {
//
// }

export default class EntryAbility extends UIAbility {
  // 最早的创建窗口的钩子
  // 提前将后续使用的上下文context放到appstorage  共享给整个应用
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    // hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
    logger.info('生命周期', 'Ability onCreate')

    // AppStorage.setOrCreate<string>('username', 'zs')
    AppStorage.setOrCreate('context', this.context)
  }

  onDestroy(): void {
    // hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
    logger.info('生命周期', 'Ability onDestroy')
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    // hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    logger.info('生命周期', 'Ability onWindowStageCreate')

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    // hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
    logger.info('生命周期', 'Ability onWindowStageDestroy') //  数据描述 数据本体
  }

  onForeground(): void {
    // Ability has brought to foreground
    // hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
    logger.info('生命周期', 'Ability onForeground')
  }

  onBackground(): void {
    // Ability has back to background
    // hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
    logger.info('生命周期', 'Ability onBackground')

    // info  error   warn  这些日志 都会在项目真正上线运行会打印
    // debug 只会开发调试阶段会打印  一旦项目发布上线  这些debug打印自动去除
    // hilog.debug(0x0001, "KKKK", "%{public}s World %{public}d %{public}s", "hello", 3, true, false, 'zs');
  }
}