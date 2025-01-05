// theme.ets 文件
export namespace SkinTheme {

  declare type THEME = Resource | string | Color;

  export interface Theme {
    page_background: THEME;
    background_color: THEME;
    text_color: THEME;
    placeholder: THEME;
  }

  class LightTheme implements Theme {
    page_background = 'transparent';
    background_color = "#eeeeee";
    text_color = Color.Black;
    placeholder = Color.Black;
  }

  class DarkTheme implements Theme {
    page_background = 'transparent';
    background_color = '#202020';
    text_color = '#fcfcfc';
    placeholder = 'rgba(66,66,66, 0.5)';
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
  export function getTheme(theme: number = 1): Theme {
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