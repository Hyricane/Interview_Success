import { hilog } from "@kit.PerformanceAnalysisKit"

// console.log()
export class Logger {
  domain: number
  tag: string
  format: string

  constructor(domain: number, tag: string, format: string) {
    this.domain = domain
    this.tag = tag
    this.format = format
  }

  info(a: string, b: string) {
    // xx: xxx
    hilog.info(this.domain, this.tag, this.format, a, b)
  }

  warn(a: string, b: string) {
    hilog.warn(this.domain, this.tag, this.format, a, b)
  }

  error(a: string, b: string) {
    hilog.error(this.domain, this.tag, this.format, a, b)
  }

  debug(a: string, b: string) {
    hilog.debug(this.domain, this.tag, this.format, a, b)
  }
}


// console.info()  class 多写
export let logger = new Logger(0x0001, 'INTERVIEW', '%{public}s: %{public}s')

// export let logger2 = new Logger(0x0002, 'ZHIBO', '%{public}s: %{public}s')


// logger.info('姓名', '张三')
// logger.error('年龄', '19')

// 方法封装在实例上  而不是类上
// Logger.info()
// Logger.error()
