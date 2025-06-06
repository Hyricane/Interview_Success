import axios, { AxiosError, AxiosRequestConfig, AxiosResponse } from "@ohos/axios";

//测试类型
// interface CateResType{
//   code:number
//   success:boolean
//   message:string
//   data:QuestionType[]
// }
//
// async aboutToAppear(){
//   const res = await axios<null,AxiosResponse<CateResType,null>,null>({
//     url:'https://api-harmony-teach.itheima.net/hm/question/type'
//   })
//
//   res.data//返回数据
//   res.data.message
//   res.data.data
  // 1.泛型麻烦 希望可以省略不需要的泛型 =>自行封装请求类
  // 2.获取返回数据麻烦,希望将res.data集成在一起 => 拦截器
// }
//由此,我们基于Axios自行封装类Http

// 定义通用类型
// T作为使用时传入的data的类型
interface INTERVIEW_ResType<T>{
  code:number
  success:boolean
  message:string,
  data:T
}

// 创建axios实例
const instance = axios.create({
  baseURL:'https://api-harmony-teach.itheima.net/hm/',
  // 最大延迟时间
  timeout:10000
})

// 添加响应拦截器
instance.interceptors.response.use((response:AxiosResponse) => {
  // 2xx 范围内的状态码都会触发该函数。
  // 剥离出关键响应数据
  if (response.data.code==10000) {
    return response.data.data
  }else {
    return Promise.reject(response.data)
  }
}, (error:AxiosError) => {
  // 超出 2xx 范围的状态码都会触发该函数。
  // 对响应错误做点什么
  return Promise.reject(error);
});

export class Http{
  //AxiosRequestConfig是Axios中封装好的对象类型,含有发送请求的所有类型
  // AxiosRequestConfig后可传泛型,即规定data[]的类型.eg AxiosRequestConfig<string>,data类型为string
  request<T,R=Object>(obj:AxiosRequestConfig<R>){
    // AxiosResponse<T,null>,形式泛型T
    // return axios<null,AxiosResponse<INTERVIEW_ResType<T>,null>,null>(obj)

    // 因为关键数据已经被剥离,所以响应数据泛型就为传入泛型
    return instance<null,T,R>(obj)
  }
}
export const http = new Http()