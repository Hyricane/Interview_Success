import { User } from "../../models"

const UserInfoKey = 'user'

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
}

export const auth = new Auth()