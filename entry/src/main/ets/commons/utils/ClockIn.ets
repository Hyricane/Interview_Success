import { auth} from './Auth'
import { http } from './Http'
import { promptAction, router } from '@kit.ArkUI'

interface ClockRes{
  clockinNumber:number
}

export class ClockIn{
  async request(){
    const user = auth.getUser()
    if (user.token) {
      if (user.token) {
        if (user.clockinNumbers==0) {
          const res = await http.request<ClockRes>({
            url:'clockin',
            method:'post'
          })
          user.clockinNumbers = res.clockinNumber
          auth.setUser(user)
          promptAction.showToast({message:'打卡成功'})
        }
        router.pushUrl({url:'pages/clockInPage'})
      }else {
        router.pushUrl({url:'pages/LoginPage'})
      }
    }
  }
}

export const clockIn = new ClockIn()