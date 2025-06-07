export class FormatTime{
  static day = 60*60*24
  static hour = 60*60
  static min = 60

  static getDHM(second:number|undefined){
    if (!second) {
      return '暂无数据'
    }

    if (second>FormatTime.day) {
      return (second/FormatTime.day).toFixed(1)+'天'
    }else if(second>FormatTime.hour){
      return (second/FormatTime.hour).toFixed(1)+'小时'
    }else{
      return (second/FormatTime.min).toFixed(0)+'分钟'
    }
  }
}
