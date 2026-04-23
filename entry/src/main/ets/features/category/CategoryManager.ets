import { FeatureResult, success } from '../common/FeatureModels';

export interface CategoryItem {
  id: string;
  type: string;
  name: string;
  color: string;
  sort: number;
}

export class CategoryManager {
  async list(type: string): Promise<CategoryItem[]> {
    return Promise.resolve([]);
  }

  async save(category: CategoryItem): Promise<FeatureResult> {
    return Promise.resolve(success(`category:${category.id}:saved`));
  }

  async remove(id: string): Promise<FeatureResult> {
    return Promise.resolve(success(`category:${id}:removed`));
  }
}
