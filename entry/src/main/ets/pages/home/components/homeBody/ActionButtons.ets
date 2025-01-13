import { router } from "@kit.ArkUI";
import { RouterUrlConstants } from "../../../../constants/RouterUrlConstants";

interface ActionButton {
  /**
   * 图标
   */
  iconName: string;

  /**
   * 标题
   */
  title: string;

  /**
   * 点击动作
   */
  action: (pageIndexInfos: NavPathStack) => void;
}

const ActionButtonItem: ActionButton[] = [
  {
    iconName: 'ic_octicon_thumbsup',
    title: '推荐歌单',
    action: (pageIndexInfos: NavPathStack) => {
      // pageIndexInfos.pushPathByName(RouterUrlConstants.MUSIC_COMMENT, null);
    }
  },
  {
    iconName: 'ic_trophy',
    title: '榜单',
    action: (pageIndexInfos: NavPathStack) => {
      // pageIndexInfos.pushPathByName(RouterUrlConstants.MUSIC_COMMENT, null);
    }
  },
  {
    iconName: 'ic_clock',
    title: '播放记录',
    action: (pageIndexInfos: NavPathStack) => {
      // pageIndexInfos.pushPathByName(RouterUrlConstants.MUSIC_COMMENT, null);
    }
  },
  {
    iconName: 'ic_folder_music_outline',
    title: '本地音乐',
    action: (pageIndexInfos: NavPathStack) => {
      console.log("进来")
      pageIndexInfos.pushPathByName(RouterUrlConstants.LOCAL_MUSIC, null);
    }
  },
  {
    iconName: 'ic_aliyunpan',
    title: '阿里云盘',
    action: (pageIndexInfos: NavPathStack) => {
      // pageIndexInfos.pushPathByName(RouterUrlConstants.MUSIC_COMMENT, null);
    }
  }
]

export { ActionButtonItem, ActionButton }