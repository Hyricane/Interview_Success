import { hilog } from "@kit.PerformanceAnalysisKit";

export class Logger{
  // 领域标识
  domain: number
  // 日志标识
  tag: string
  // 格式字符串
  // '%{}s/d'
  format: string

  info(a:string,b:string){
    hilog.info(this.domain,this.tag,this.format,a,b)
  }
  warn(a:string,b:string){
    hilog.warn(this.domain,this.tag,this.format,a,b)
  }
  error(a:string,b:string){
    hilog.error(this.domain,this.tag,this.format,a,b)
  }
  debug(a:string,b:string){
    hilog.debug(this.domain,this.tag,this.format,a,b)
  }

  constructor(domain: number, tag: string, format: string) {
    this.domain = domain;
    this.tag = tag;
    this.format = format;
  }
}

export let logger = new Logger(0x0001,'测试','%{public}s %{public}s')