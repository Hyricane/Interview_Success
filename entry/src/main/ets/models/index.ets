// 后端返回数据的类型:
export interface PageData {
  total: number
  pageTotal: number
  rows: QuestionItem[]
}

// 单个分类
export interface QuestionType {
  id: number
  name: string
  displayNewestFlag: 0 | 1
}

// 单个面试题类型
export interface QuestionItem {
  id: string;

  /* 题干 */
  stem: string;

  /* 难度 */
  difficulty: number;

  /* 点赞数 */
  likeCount: number;

  /* 浏览数 */
  views: number;

  /* 是否已看 */
  readFlag: 0 | 1;
}

// 排序方式的枚举
export enum SortType {
  Default = 0,
  Easy2Hard = 10,
  Hard2Easy = 11,
  Low2High = 20,
  High2Low = 21,
  Recommend = 30
}

export interface User {
  id: string
  username: string
  avatar: string
  // ! 很重要很重要很重要
  // 登录时 服务端返回的用户标识(必须返回)
  // 无状态(记不住)  导致我们每次请求后端都需要带token
  // token怎么生成 => 后端根据用户信息加密而成的一段字符串
  // ! token很重要 且后续每次请求都得携带(拦截器)
  // ! token是有有效期的   会有过期的一天
  // 如果过期了(后端会返回一个401状态码 ) 重新登录即可
  // 200 成功   3xx重定向   4xx客户端错误(404  401身份信息有问题)    5xx服务器错误
  // 只要token过期了 所有的请求都会带着这个过期token  被401 => 响应拦截器
  token: string
  nickName?: string
  // 学习时长
  totalTime?: number
  // 打卡次数
  clockinNumbers?: number
}

// 试题详情类型
export interface QuestionDetail extends QuestionItem {
  /* 答案 */
  answer: string;

  /* 是否收藏 */
  collectFlag: 0 | 1;

  /* 是否点赞 */
  likeFlag: 0 | 1;

  /* 所属模块 */
  stage: string[];
}

export interface QuestionPageParams {
  item: QuestionDetail;
  list: QuestionItem[];
}

export interface TimeItem {
  questionId: string;
  startTime: number;
  endTime: number;
}

export interface ClockInItem {
  id: string,
  createdAt: string
}

export interface ClockInfo {
  flag: boolean
  clockinNumbers: number
  totalClockinNumber: number
  clockins: ClockInItem[]
}

export interface ClockInfoParams {
  year: string,
  month: string
}