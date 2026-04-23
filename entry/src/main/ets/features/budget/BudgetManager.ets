import { FeatureResult, success } from '../common/FeatureModels';

export interface CategoryBudget {
  category: string;
  limit: number;
  used: number;
}

export class BudgetManager {
  async listCategoryBudgets(): Promise<CategoryBudget[]> {
    return Promise.resolve([]);
  }

  async saveCategoryBudget(budget: CategoryBudget): Promise<FeatureResult> {
    return Promise.resolve(success(`budget:${budget.category}:saved`));
  }
}
