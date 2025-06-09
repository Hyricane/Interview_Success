import { window } from "@kit.ArkUI"
import { logger } from "./Logger"

export class StatusBar {
  setDarkBar() {
    this.setBar('#000000')
  }

  setLightBar() {
    this.setBar('#ffffff')
  }

  async setBar(color: string) {
    try {
      const ctx = AppStorage.get<Context>('context')
      if (ctx) {
        const winObj = await window.getLastWindow(ctx)
        winObj.setWindowSystemBarProperties({
          statusBarContentColor: color
        })
      }
    } catch (err) {
      logger.error('StatusBar setColor error', JSON.stringify(err))
    }
  }
}

export const statusBar = new StatusBar()

// statusBar.setDarkBar()
// statusBar.setLightBar()
// statusBar.setBar('#ffffff')
// statusBar.setBar('#000000')