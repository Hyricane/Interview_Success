export interface QuestionType {
  id: number
  name: string
  displayNewestFlag: 0 | 1
}
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
// 后端返回数据的类型:
export interface PageData {
  total: number
  pageTotal: number
  rows: QuestionItem[]
}

// 排序方式
export enum SortType{
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
  token: string
  nickName?: string
  // 学习时长
  totalTime?: number
  // 打卡次数
  clockinNumbers?: number
}