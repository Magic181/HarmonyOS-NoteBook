import { BillRecordModel, FeatureResult, success } from '../common/FeatureModels';

export interface BillQuery {
  keyword?: string;
  category?: string;
  startTime?: number;
  endTime?: number;
  minAmount?: number;
  maxAmount?: number;
}

export class BillRepository {
  async list(query?: BillQuery): Promise<BillRecordModel[]> {
    return Promise.resolve([]);
  }

  async save(record: BillRecordModel): Promise<FeatureResult> {
    return Promise.resolve(success(`bill:${record.id}:saved`));
  }

  async delete(ids: number[]): Promise<FeatureResult> {
    return Promise.resolve(success(`bill:${ids.length}:deleted`));
  }
}
