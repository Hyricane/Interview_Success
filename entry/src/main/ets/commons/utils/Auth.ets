import { User } from "../../models"
import { router } from "@kit.ArkUI"

export const UserInfoKey = 'user' // 用户信息数据对应的那个键名

export class Auth {
  // 持久化
  initUser() {
    PersistentStorage.persistProp<User>(UserInfoKey, {} as User)
  }

  setUser(obj: User) {
    AppStorage.set(UserInfoKey, obj)
  }

  getUser() {
    return AppStorage.get<User>(UserInfoKey) || {} as User
  }

  // 封装一个页面访问控制逻辑
  // 用于某些重要页面 在游客访问时 跳转至登录(登录完成后 需要回到刚刚没去成的页面)
  // Authorization 授权 登录
  checkAuth(obj: router.RouterOptions) {
    const user = this.getUser()
    if (user.token) {
      // 登录了
      router.pushUrl(obj) // 会拿到item
    } else {
      // 没登录 去登录(带上个参数 刚刚没去成的页面url)
      const params = obj.params as Record<string, string> || {}
      params.return_url = obj.url
      router.pushUrl({
        url: '/pages/LoginPage'.slice(1),
        params: params // 原来的参数一个不落地过去了   但是少个东西
        // {
        //   // 一会登录完成后的回跳地址 原来的obj.params.item参数得带着
        //   return_url: obj.url, // 你想去的页面url
        //   // item: (obj.params as Record<string, string>).item
        // }
      })
    }
  }
}

export const auth = new Auth()

// 设计一下这个api的使用姿势
// router.pushUrl({ url: 'pages/QuestionDetail' })  不会检查有没有登录
// auth.checkAuth({ url: 'pages/QuestionDetail' })  这个会有检查登录的操作

// auth.initUser()
// auth.setUser({})
// const res = auth.getUser()

// 应用一打开  初始化一个数据
// PersistentStorage.persistProp('user', {})

// 后续改数据
// @StorageLink('user')    Appstorage.set

// 后续使用数据
// @StorageProp('user')    Appstorage.get