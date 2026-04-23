import { BillRecordModel, FeatureResult, success } from '../common/FeatureModels';

export interface RecurringBillRule {
  id: string;
  record: BillRecordModel;
  dayOfMonth: number;
  enabled: boolean;
}

export class RecurringBillManager {
  async listRules(): Promise<RecurringBillRule[]> {
    return Promise.resolve([]);
  }

  async saveRule(rule: RecurringBillRule): Promise<FeatureResult> {
    return Promise.resolve(success(`recurring:${rule.id}:saved`));
  }
}
