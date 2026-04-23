import { BillRecordModel, FeatureResult, success } from '../common/FeatureModels';

export class DataExportManager {
  toJson(records: BillRecordModel[]): string {
    return JSON.stringify(records);
  }

  toCsv(records: BillRecordModel[]): string {
    const header = 'id,type,category,title,amount,timestamp';
    const rows = records.map((item: BillRecordModel) => {
      return `${item.id},${item.type},${item.category},${item.title},${item.amount},${item.timestamp}`;
    });
    return [header].concat(rows).join('\n');
  }

  async exportFile(records: BillRecordModel[], format: string): Promise<FeatureResult> {
    return Promise.resolve(success(`export:${format}:${records.length}`));
  }
}
