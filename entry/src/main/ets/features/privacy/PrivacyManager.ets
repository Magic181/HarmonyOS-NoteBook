import { FeatureResult, success } from '../common/FeatureModels';

export class PrivacyManager {
  async hasAcceptedPolicy(): Promise<boolean> {
    return Promise.resolve(false);
  }

  async acceptPolicy(): Promise<FeatureResult> {
    return Promise.resolve(success('privacy:accepted'));
  }
}
