import promptAction from '@ohos.promptAction';
import { SkinTheme } from '../core/Theme'

let theme: SkinTheme.Theme = SkinTheme.getTheme();

class Toast {

  async success(message: string = '') {
    promptAction.showToast({message: message, textColor: theme.toastSuccessTextColor})
  }

  async warn(message: string = '') {
    promptAction.showToast({message: message, textColor: theme.toastWarnTextColor})
  }

  async error(message: string = '') {
    promptAction.showToast({message: message, textColor: theme.toastErrorTextColor})
  }
}

export default new Toast()