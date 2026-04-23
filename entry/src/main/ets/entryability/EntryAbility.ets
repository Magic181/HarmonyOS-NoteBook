import { AbilityConstant, Configuration, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

const DOMAIN = 0x0000;
const TAG = 'EntryAbility';
const MAIN_PAGE = 'pages/Index';
const FALLBACK_PAGE = 'pages/Fallback';
const LIGHT_WINDOW_BACKGROUND = '#F5F8F8';
const DARK_WINDOW_BACKGROUND = '#111827';

export default class EntryAbility extends UIAbility {
  private windowStage?: window.WindowStage;
  private mainWindow?: window.Window;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    this.releaseWindowResources();
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onWindowStageCreate');
    this.windowStage = windowStage;
    this.prepareWindowBackground(windowStage);
    this.loadMainContent(windowStage);
  }

  onWindowStageDestroy(): void {
    this.releaseWindowResources();
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    this.applyWindowBackground(newConfig.colorMode);
    hilog.info(DOMAIN, TAG, 'Configuration updated. colorMode: %{public}d', newConfig.colorMode ?? -1);
  }

  onForeground(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onBackground');
  }

  private prepareWindowBackground(windowStage: window.WindowStage): void {
    windowStage.getMainWindow((err, mainWindow) => {
      if (err.code) {
        hilog.warn(DOMAIN, TAG, 'Failed to get main window. Cause: %{public}s', JSON.stringify(err));
        return;
      }

      this.mainWindow = mainWindow;
    });
  }

  private applyWindowBackground(colorMode?: ConfigurationConstant.ColorMode): void {
    if (!this.mainWindow) {
      return;
    }

    const backgroundColor = colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK
      ? DARK_WINDOW_BACKGROUND
      : LIGHT_WINDOW_BACKGROUND;
    try {
      this.mainWindow.setWindowBackgroundColor(backgroundColor);
    } catch (error) {
      hilog.warn(DOMAIN, TAG, 'Failed to apply window background. Cause: %{public}s', JSON.stringify(error));
    }
  }

  private loadMainContent(windowStage: window.WindowStage): void {
    windowStage.loadContent(MAIN_PAGE, (err) => {
      if (err.code) {
        hilog.error(DOMAIN, TAG, 'Failed to load main content. Cause: %{public}s', JSON.stringify(err));
        this.loadFallbackContent(windowStage);
        return;
      }

      hilog.info(DOMAIN, TAG, 'Succeeded in loading main content.');
    });
  }

  private loadFallbackContent(windowStage: window.WindowStage): void {
    windowStage.loadContent(FALLBACK_PAGE, (fallbackErr) => {
      if (fallbackErr.code) {
        hilog.error(DOMAIN, TAG, 'Failed to load fallback content. Cause: %{public}s', JSON.stringify(fallbackErr));
        return;
      }

      hilog.info(DOMAIN, TAG, 'Succeeded in loading fallback content.');
    });
  }

  private releaseWindowResources(): void {
    this.mainWindow = undefined;
    this.windowStage = undefined;
  }
}
