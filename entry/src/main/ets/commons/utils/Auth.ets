import { User } from "../../models"
import { router } from "@kit.ArkUI"

export const UserInfoKey = 'user'

export class Auth{
  initUser(){
    PersistentStorage.persistProp<User>(UserInfoKey,{} as User)
  }

  setUser(obj:User){
    AppStorage.set(UserInfoKey,obj)
  }

  getUser(){
    return AppStorage.get<User>(UserInfoKey) || {} as User
  }

  checkAuth(obj:router.RouterOptions){
    if (this.getUser().token) {
      router.pushUrl(obj)
    }else{
      router.pushUrl({ url: 'pages/LoginPage',params:{return_url:obj.url}})
    }
  }
}

export const auth = new Auth()