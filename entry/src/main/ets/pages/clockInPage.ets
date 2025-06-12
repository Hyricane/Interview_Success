import { HmCalendar } from '@ohmos/calendar'
@Entry
@Component
struct ClockInPage {

  build() {
    Column(){
      Text('打卡')
      HmCalendar({
        selectedDays: [
          { date: '2025-06-12' },
        ]
      })
        .borderRadius(8)
        .border({ width: 0.5, color: '#ededed' })
        .shadow({ color: '#ededed', radius: 16 })
        .backgroundColor($r('app.color.white'))
    }
    .height('100%')
    .width('100%')
  }
}