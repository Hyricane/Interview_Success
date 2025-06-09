import { emitter } from "@kit.BasicServicesKit"

interface House {
  address: string
  price: number
  floor: number
}

@Component
export struct ProjectPage {
  aboutToAppear(): void {
    // 模拟小明订阅消息
    emitter.on('house', (obj) => {
      // 一旦有house消息 立刻触发这个回调
      let res = obj.data as House
      AlertDialog.show({ message: `我有${res.address}住啦` })
    })
  }

  build() {
    Text('项目')
  }
}