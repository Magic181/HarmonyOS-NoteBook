export interface BillRecordModel {
  id: number;
  type: string;
  category: string;
  title: string;
  amount: number;
  timestamp: number;
}

export interface FeatureResult {
  ok: boolean;
  message: string;
}

export function success(message: string): FeatureResult {
  return { ok: true, message };
}

export function failure(message: string): FeatureResult {
  return { ok: false, message };
}
