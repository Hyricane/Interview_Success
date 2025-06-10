import { TimeItem } from '../../models'
import { http } from './Http'

class Tracking{
  list:TimeItem[]=[]

  record(startTime:number,endTime:number,questionId:string){
    this.list.push({
      startTime,
      endTime,
      questionId
    })
  }

  async report(){
    await http.request<null>({
      url:'time/tracking',
      method:'post',
      data:{
        timeList:this.list = []
      }
    })
  }
}

export const tracking = new Tracking()