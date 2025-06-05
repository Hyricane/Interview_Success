import axios, { AxiosRequestConfig, AxiosResponse } from "@ohos/axios";

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
  // 1.泛型麻烦 希望可以省略不需要的泛型
  // 2.获取返回数据麻烦,希望将res.data集成在一起
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

export class Http{
  //AxiosRequestConfig是Axios中封装好的对象类型,含有发送请求的所有类型
  // AxiosRequestConfig后可传泛型,即规定data[]的类型.eg AxiosRequestConfig<string>,data类型为string
  request<T>(obj:AxiosRequestConfig){
    // AxiosResponse<T,null>,形式泛型T
    return axios<null,AxiosResponse<INTERVIEW_ResType<T>,null>,null>(obj)
  }
}