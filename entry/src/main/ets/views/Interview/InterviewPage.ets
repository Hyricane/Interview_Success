import { emitter } from "@kit.BasicServicesKit"

@Component
export struct InterviewPage {
  build() {
    Text('面经')
      .onClick(() => {
        emitter.emit(
          'house',
          {
            data:
            {
              address: '古北壹号',
              price: 1000,
              floor: 5
            }
          }
        )
      })
  }
}