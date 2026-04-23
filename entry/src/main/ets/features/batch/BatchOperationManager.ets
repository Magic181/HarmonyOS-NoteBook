import { FeatureResult, success } from '../common/FeatureModels';

export class BatchOperationManager {
  async deleteBills(ids: number[]): Promise<FeatureResult> {
    return Promise.resolve(success(`batch:${ids.length}:deleted`));
  }

  async moveCategory(ids: number[], category: string): Promise<FeatureResult> {
    return Promise.resolve(success(`batch:${ids.length}:moved:${category}`));
  }
}
