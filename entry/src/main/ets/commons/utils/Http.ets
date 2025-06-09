import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from "@ohos/axios"
import { auth } from "."
import { QuestionType, User } from "../../models"
import { promptAction, router } from "@kit.ArkUI"

// 面试通项目 后端返回的数据通用类型
interface INTERVIEW_ResType<T> {
  code: number
  success: boolean
  message: string
  data: T
}

// 创建axios实例时
const instance = axios.create({
  // 基础地址
  baseURL: 'https://api-harmony-teach.itheima.net/hm/',
  // 超时时间   1秒内数据回来就ok   超过1秒数据没回来 就算请求失败
  timeout: 10000,
})
// !添加请求拦截器
// 所有请求都得来这边执行以下 才能发送到服务器
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  // 在发送请求之前做些什么
  // ! config 就是各位在发请求时传的那个 obj
  // config.url = 'https://www.baidu.com'
  // config.headers.a = 'b'
  const user = auth.getUser()
  if (user.token) {
    // 有token 再加请求头
    config.headers.Authorization = `Bearer ${user.token}`
  }
  // AlertDialog.show({ message: JSON.stringify(config, null, 4) })

  return config;
}, (error: AxiosError) => {
  // 对请求错误做些什么
  return Promise.reject(error);
});

// 给instance添加响应拦截器
instance.interceptors.response.use((response: AxiosResponse) => {
  // 2xx 范围内的状态码都会触发该函数。
  // 对响应数据做点什么
  if (response.data.code == 10000) {
    return response.data.data // 需要将关键数据剥离出来 供给客户端开发
  } else {
    // 这次请求成功了 但是没拿到数据 => 返回失败的promise
    // AlertDialog.show({message: ''})
    return Promise.reject(response.data)
  }
}, (error: AxiosError) => {
  // 超出 2xx 范围的状态码都会触发该函数。
  // 咱们看看响应一旦出错 拿到的信息
  // AlertDialog.show({ message: error.response?.status.toString() })

  if (error.response?.status == 401) {
    // 401
    // 1. 过期的信息删除
    auth.setUser({} as User)
    // 2. 回到登录
    router.pushUrl({ url: 'pages/LoginPage' }, router.RouterMode.Single)
    // 3. 给个提示
    promptAction.showToast({ message: '重新登录' })
  }


  // 对响应错误做点什么
  return Promise.reject(error);
});


// 改造一个更好用的axios
export class Http {
  // AxiosRequestConfig axios提供的请求对象类型
  request<T, R = Object>(obj: AxiosRequestConfig<R>) {
    // !之前第二个泛型很复杂  因为返回的数据没剥离
    // !现在数据剥离了  而且剥离干干净净  就是你要的数据  所以类型就是你要的数据的类型
    return instance<null, T, R>(obj)
  }
}

export const http = new Http()

// http.request<后端返回的真正数据的类型, 提交过去的类型>({ url: '', data: {} })

// http.request({
//   url: '',
//   method: '',
//   params: {},
//   data
// })
