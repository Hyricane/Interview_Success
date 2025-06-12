import { TimeItem } from '../../models'
import { http } from './Http'
import { preferences } from "@kit.ArkData";
import { Context } from '@kit.AbilityKit';

class Tracking{
  //使用preferences进行持久化处理,方便多条发送请求,减轻服务器压力
  store: preferences.Preferences | null = null;
  //get方法的键
  dataKey: string = "time-list";

  getStore(){
    if (!this.store) {
      const ctx = AppStorage.get<Context>('context')
      this.store = preferences.getPreferencesSync(ctx,{name:'tracking-store'})
    }                                                                                                                                                                                                                                 

    return this.store
  }
  // preference的put方法只能放boolean,string,number及其组成的数组,而我们需要传递的是包含多个属性的对象
  record(startTime:number,endTime:number,questionId:string){
    // 先根据键获得值,未获取到则为空数组[]
    const json = this.getStore().getSync(this.dataKey,'[]')
    // 用JSON将字符串数组转为TiameItem类型的对象数组,并存到list中
    const list = JSON.parse(json as string) as TimeItem[]
    //此时可以添加对象进数组
    list.push({startTime,endTime,questionId})

    // 把list重新使用JSON转为字符串数组,然后使用putSync储存
    this.getStore().putSync(this.dataKey,JSON.stringify(list))
    this.getStore().flushSync()//持久化处理
  }

  async report(force:boolean = false){
    //拿取数据
    const json = this.getStore().getSync(this.dataKey,'[]')
    //转为对象数组
    const list = JSON.parse(json as string) as TimeItem[]

    //满5条上报,减少请求次数,force用于强行上报,强行上报时list中需要有数据
    if (list.length>5 || (force&&list.length)) {
      await http.request<null>({
            url:'time/tracking',
            method:'post',
            data:{
              timeList:list
            }
          })
      //上报完成删除持久化数据,以免重复上报
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