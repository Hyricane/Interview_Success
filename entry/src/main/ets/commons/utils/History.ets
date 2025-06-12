import { preferences } from "@kit.ArkData";

// 面向对象
// 获取首选项实例对象(有很多方法)
// 增  putSync
// 删  deleteSync
// 改  putSync      flushSync

// 查  getSync

export class History {
  store: preferences.Preferences | null = null;

  getStore() {
    if (!this.store) {
      const context = AppStorage.get<Context>("context");
      this.store = preferences.getPreferencesSync(context, { name: "history-store" });
    }
    return this.store;
  }

  // 存一个关键字
  setItem(keyword: string) {
    this.getStore().putSync(keyword, keyword) // vue:vue     record:record    ts:ts
    this.getStore().flushSync()
  }

  // 删
  delItem(keyword: string) {
    this.getStore().deleteSync(keyword);
    this.getStore().flushSync();
  }

  // 查所有搜索关键字
  getAll() {
    const obj = this.getStore().getAllSync()
    // { vue: vue, ts: ts, ui: ui }
    // ['vue', 'ts', 'ui']
    return Object.keys(obj)
  }

  // 清除首选项 持久化的数据
  clear() {
    this.getStore().clearSync() // 清空
    this.getStore().flushSync() // 永久保存
  }
}

export const history = new History();