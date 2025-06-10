import { TimeItem } from '../../models'
import { http } from './Http'
import { preferences } from "@kit.ArkData";
import { Context } from '@kit.AbilityKit';

class Tracking{
  store: preferences.Preferences | null = null;
  dataKey: string = "time-list";

  getStore(){
    if (!this.store) {
      const ctx = AppStorage.get<Context>('context')
      this.store = preferences.getPreferencesSync(ctx,{name:'tracking-store'})
    }

    return this.store
  }

  record(startTime:number,endTime:number,questionId:string){
    const json = this.getStore().getSync(this.dataKey,'[]')
    const list = JSON.parse(json as string) as TimeItem[]
    list.push({startTime,endTime,questionId})

    this.getStore().putSync(this.dataKey,JSON.stringify(list))
    this.getStore().flushSync()
  }

  async report(force:boolean){
    const json = this.getStore().getSync(this.dataKey,'[]')
    const list = JSON.parse(json as string) as TimeItem[]

    if (list.length>5 || (force&&list.length)) {
      await http.request<null>({
            url:'time/tracking',
            method:'post',
            data:{
              timeList:list
            }
          })
      this.getStore().deleteSync(this.dataKey)
      await this.getStore().flushSync()
    }
  }

  // record(startTime:number,endTime:number,questionId:string){
  //   this.list.push({
  //     startTime,
  //     endTime,
  //     questionId
  //   })
  // }
  //
  // async report(){
  //   await http.request<null>({
  //     url:'time/tracking',
  //     method:'post',
  //     data:{
  //       timeList:this.list = []
  //     }
  //   })
  // }
}

export const tracking = new Tracking()