import { BillRecordModel } from '../common/FeatureModels';
import { BillQuery } from '../storage/BillRepository';

export class BillFilter {
  match(record: BillRecordModel, query: BillQuery): boolean {
    if (query.keyword && record.title.indexOf(query.keyword) < 0) {
      return false;
    }
    if (query.category && record.category !== query.category) {
      return false;
    }
    if (query.startTime !== undefined && record.timestamp < query.startTime) {
      return false;
    }
    if (query.endTime !== undefined && record.timestamp > query.endTime) {
      return false;
    }
    if (query.minAmount !== undefined && record.amount < query.minAmount) {
      return false;
    }
    if (query.maxAmount !== undefined && record.amount > query.maxAmount) {
      return false;
    }
    return true;
  }
}
