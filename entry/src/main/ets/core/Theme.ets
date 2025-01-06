// theme.ets 文件
export namespace SkinTheme {

  declare type THEME = Resource | string | Color;

  export interface Theme {
    pageBackgroundColor: THEME;
    backgroundColor: THEME;
    searchBackgroundColor: THEME;
    gridBackgroundColor: THEME;
    background: THEME;
    fontColor: THEME;
    fillColor: THEME;
    placeholderColor: THEME;
    dividerColor: THEME;
    iconColor: THEME;
  }

  class LightTheme implements Theme {
    searchBackgroundColor = 'rgba(234, 234, 234, 0.4)';
    gridBackgroundColor = 'rgba(234, 234, 234, 0.4)';
    pageBackgroundColor = Color.White;
    backgroundColor = '';
    background = '';
    fontColor = '#343434';
    fillColor = '';
    iconColor = '#343434';
    placeholderColor = '';
    dividerColor = '#71c9ce';
  }

  class DarkTheme implements Theme {
    searchBackgroundColor = 'transparent';
    gridBackgroundColor = 'transparent';
    pageBackgroundColor = 'transparent';
    backgroundColor = 'transparent';
    background = '#202020';
    fontColor = '#fcfcfc';
    fillColor = '#fcfcfc';
    iconColor = '#fcfcfc';
    placeholderColor = 'rgba(66,66,66, 0.5)';
    dividerColor = 'rgba(66,66,66, 0.5)';
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