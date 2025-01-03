export class Plugin {

  funcCode: string;
  pluginPath: string;

  constructor(
    funcCode: string ,
    pluginPath: string,
  ) {
    this.funcCode = funcCode;
    this.pluginPath = pluginPath;
  }

  public getPluginPath() {
    return this.pluginPath;
  }

}