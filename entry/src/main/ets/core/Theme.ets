// theme.ets 文件
export namespace SkinTheme {

  declare type THEME = Resource | string | Color;

  export interface Theme {
    // 页面背景颜色
    pageBackgroundColor: THEME;
    // 组件背景颜色
    backgroundColor: THEME;
    // 搜索组件背景颜色
    searchBackgroundColor: THEME;
    // 方块格子背景颜色
    gridBackgroundColor: THEME;
    // 背景
    background: THEME;
    // 字体颜色
    fontColor: THEME;
    // 确认按钮字体颜色
    confirmButtFontColor: THEME;
    // 取消按钮字体颜色
    cancelButtFontColor: THEME;
    // 天才颜色
    fillColor: THEME;
    // 输入框 placeholder 颜色
    placeholderColor: THEME;
    dividerColor: THEME;
    // 图标颜色
    iconColor: THEME;
    // toast Success字体颜色
    toastSuccessTextColor: THEME;
    // toast warn字体颜色
    toastWarnTextColor: THEME;
    // toast error字体颜色
    toastErrorTextColor: THEME;
    // 副标题字体颜色
    subtitleTextColor: THEME;
  }

  class LightTheme implements Theme {
    searchBackgroundColor = 'rgba(234, 234, 234, 0.4)';
    gridBackgroundColor = 'rgba(234, 234, 234, 0.4)';
    pageBackgroundColor = Color.White;
    backgroundColor = '';
    background = '';
    fontColor = '#343434';
    confirmButtFontColor = '#E3803C';
    cancelButtFontColor = '#202020';
    fillColor = '';
    iconColor = '#343434';
    placeholderColor = '';
    dividerColor = '#71c9ce';
    toastSuccessTextColor = '#202020';
    toastWarnTextColor = '#E6A23C';
    toastErrorTextColor = '#F56C6C';
    subtitleTextColor = '#606266';
  }

  class DarkTheme implements Theme {
    searchBackgroundColor = 'transparent';
    gridBackgroundColor = 'transparent';
    pageBackgroundColor = 'transparent';
    backgroundColor = 'transparent';
    background = '#202020';
    fontColor = '#fcfcfc';
    confirmButtFontColor = '#409EFF';
    cancelButtFontColor = '#202020';
    fillColor = '#fcfcfc';
    iconColor = '#fcfcfc';
    placeholderColor = 'rgba(66,66,66, 0.5)';
    dividerColor = 'rgba(66,66,66, 0.5)';
    toastSuccessTextColor = '#202020';
    toastWarnTextColor = '#E6A23C';
    toastErrorTextColor = '#F56C6C';
    subtitleTextColor = '#F56C6C';
  }

  // background: 'transparent',
  // text: '#fcfcfc',
  // textSecondary: Color('#fcfcfc').alpha(0.7).toString(),
  // primary: '#3FA3B5',
  // pageBackground: '#202020',
  // shadow: '#999',
  // appBar: '#262626',
  // appBarText: '#fcfcfc',
  // musicBar: '#262626',
  // musicBarText: '#fcfcfc',
  // divider: 'rgba(255,255,255,0.1)',
  // listActive: 'rgba(255,255,255,0.1)', // 在手机上表现是ripple
  // mask: 'rgba(33,33,33,0.8)',
  // backdrop: '#303030',
  // tabBar: '#303030',
  // placeholder: 'rgba(66,66,66, 0.5)',
  // success: '#08A34C',
  // danger: '#FC5F5F',
  // info: '#0A95C8',
  // card: '#33333388',
  export function getTheme(theme: number = 0): Theme {
    // let key = "app_global_theme_" + theme;
    // var cachedTheme = DataManager.getDataSource().getData(key, null);
    // if (!cachedTheme) {
    //   cachedTheme = (0 == theme ? new LightTheme() : new NightTheme());
    //   // DataManager.getDataSource().putData(key, cachedTheme);
    // }
    // return cachedTheme as Theme;

    return (0 == theme ? new LightTheme() : new DarkTheme());
  }
}