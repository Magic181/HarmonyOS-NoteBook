interface BillRecord {
  id: number;
  type: string;
  category: string;
  title: string;
  amount: number;
  time: string;
}

interface CategoryMeta {
  name: string;
  color: string;
}

interface CategoryStat {
  name: string;
  color: string;
  total: number;
  count: number;
  rate: number;
}

interface TrendPoint {
  label: string;
  amount: number;
  count: number;
}

interface ThemeMeta {
  name: string;
  primary: string;
  soft: string;
  surface: string;
  warn: string;
}

const EXPENSE_CATEGORIES: CategoryMeta[] = [
  { name: '餐饮', color: '#E98155' },
  { name: '交通', color: '#5D8AA8' },
  { name: '购物', color: '#C87086' },
  { name: '娱乐', color: '#8B7FB8' },
  { name: '居家', color: '#7D9A72' },
  { name: '学习', color: '#D4A24C' },
  { name: '医疗', color: '#6EA6A1' },
  { name: '旅行', color: '#6F8FC7' },
  { name: '其他', color: '#8A8F98' }
];

const INCOME_CATEGORIES: CategoryMeta[] = [
  { name: '工资', color: '#5E9F78' },
  { name: '兼职', color: '#5D8AA8' },
  { name: '理财', color: '#D4A24C' },
  { name: '红包', color: '#C87086' },
  { name: '其他', color: '#8A8F98' }
];

const THEMES: ThemeMeta[] = [
  { name: '静谧蓝', primary: '#4F7F98', soft: '#E8F0F3', surface: '#F5F8F8', warn: '#E98155' },
  { name: '活力橙', primary: '#D98654', soft: '#F8ECE3', surface: '#FBF7F3', warn: '#C75B55' },
  { name: '松石绿', primary: '#5F9A8B', soft: '#E7F2EE', surface: '#F5FAF8', warn: '#D88255' },
  { name: '沉静紫', primary: '#7F75A8', soft: '#EFECF6', surface: '#F8F7FB', warn: '#D46D62' }
];

const TREND_LABELS: string[] = ['周一', '周二', '周三', '周四', '周五', '昨天', '今天'];

@Entry
@Component
struct Index {
  @State activeTab: number = 0;
  @State reportType: string = '支出';
  @State recordType: string = '支出';
  @State selectedCategory: string = '餐饮';
  @State amountText: string = '';
  @State noteText: string = '';
  @State aiText: string = '';
  @State editingId: number = -1;
  @State monthlyBudget: number = 3000;
  @State themeIndex: number = 0;
  @State records: BillRecord[] = [
    { id: 1, type: '支出', category: '餐饮', title: '午饭', amount: 35, time: '今天 12:20' },
    { id: 2, type: '支出', category: '交通', title: '地铁通勤', amount: 7, time: '今天 08:45' },
    { id: 3, type: '收入', category: '工资', title: '四月工资', amount: 8200, time: '昨天 18:00' },
    { id: 4, type: '支出', category: '购物', title: '生活用品', amount: 128.5, time: '昨天 20:10' },
    { id: 5, type: '支出', category: '娱乐', title: '电影票', amount: 48, time: '周二 21:30' },
    { id: 6, type: '支出', category: '学习', title: '课程订阅', amount: 199, time: '周一 09:15' }
  ];

  private currentTheme(): ThemeMeta {
    if (this.themeIndex < 0 || this.themeIndex >= THEMES.length) {
      return THEMES[0];
    }
    return THEMES[this.themeIndex];
  }

  private totalByType(type: string): number {
    let total = 0;
    this.records.forEach((item: BillRecord) => {
      if (item.type === type) {
        total += item.amount;
      }
    });
    return total;
  }

  private expenseTotal(): number {
    return this.totalByType('支出');
  }

  private incomeTotal(): number {
    return this.totalByType('收入');
  }

  private balance(): number {
    return this.incomeTotal() - this.expenseTotal();
  }

  private budgetRate(): number {
    if (this.monthlyBudget <= 0) {
      return 0;
    }
    return Math.min(this.expenseTotal() / this.monthlyBudget, 1);
  }

  private money(value: number): string {
    return value.toFixed(value % 1 === 0 ? 0 : 2);
  }

  private nextId(): number {
    let maxId = 0;
    this.records.forEach((item: BillRecord) => {
      if (item.id > maxId) {
        maxId = item.id;
      }
    });
    return maxId + 1;
  }

  private currentCategories(): CategoryMeta[] {
    return this.recordType === '支出' ? EXPENSE_CATEGORIES : INCOME_CATEGORIES;
  }

  private categoryColor(category: string): string {
    let color = '#8A8F98';
    EXPENSE_CATEGORIES.concat(INCOME_CATEGORIES).forEach((item: CategoryMeta) => {
      if (item.name === category) {
        color = item.color;
      }
    });
    return color;
  }

  private categoryTotalByType(type: string, category: string): number {
    let total = 0;
    this.records.forEach((item: BillRecord) => {
      if (item.type === type && item.category === category) {
        total += item.amount;
      }
    });
    return total;
  }

  private categoryCountByType(type: string, category: string): number {
    let count = 0;
    this.records.forEach((item: BillRecord) => {
      if (item.type === type && item.category === category) {
        count++;
      }
    });
    return count;
  }

  private countByType(type: string): number {
    let count = 0;
    this.records.forEach((item: BillRecord) => {
      if (item.type === type) {
        count++;
      }
    });
    return count;
  }

  private averageByType(type: string): number {
    const count = this.countByType(type);
    if (count === 0) {
      return 0;
    }
    return this.totalByType(type) / count;
  }

  private categoryStats(type: string): CategoryStat[] {
    const metas = type === '支出' ? EXPENSE_CATEGORIES : INCOME_CATEGORIES;
    const total = this.totalByType(type);
    let stats: CategoryStat[] = [];
    metas.forEach((item: CategoryMeta) => {
      const categoryAmount = this.categoryTotalByType(type, item.name);
      if (categoryAmount > 0) {
        stats.push({
          name: item.name,
          color: item.color,
          total: categoryAmount,
          count: this.categoryCountByType(type, item.name),
          rate: total > 0 ? categoryAmount / total * 100 : 0
        });
      }
    });
    stats.sort((left: CategoryStat, right: CategoryStat) => right.total - left.total);
    return stats;
  }

  private topCategoryStat(type: string): CategoryStat {
    const stats = this.categoryStats(type);
    if (stats.length > 0) {
      return stats[0];
    }
    return { name: '暂无', color: '#8A8F98', total: 0, count: 0, rate: 0 };
  }

  private recordDayIndex(time: string): number {
    if (time.indexOf('刚刚') >= 0 || time.indexOf('今天') >= 0) {
      return 6;
    }
    if (time.indexOf('昨天') >= 0) {
      return 5;
    }
    if (time.indexOf('周一') >= 0) {
      return 0;
    }
    if (time.indexOf('周二') >= 0) {
      return 1;
    }
    if (time.indexOf('周三') >= 0) {
      return 2;
    }
    if (time.indexOf('周四') >= 0) {
      return 3;
    }
    if (time.indexOf('周五') >= 0 || time.indexOf('周六') >= 0 || time.indexOf('周日') >= 0) {
      return 4;
    }
    return 6;
  }

  private trendPoints(type: string): TrendPoint[] {
    let points: TrendPoint[] = [];
    for (let index = 0; index < TREND_LABELS.length; index++) {
      points.push({ label: TREND_LABELS[index], amount: 0, count: 0 });
    }
    this.records.forEach((item: BillRecord) => {
      if (item.type === type) {
        const dayIndex = this.recordDayIndex(item.time);
        points[dayIndex].amount += item.amount;
        points[dayIndex].count++;
      }
    });
    return points;
  }

  private maxTrendAmount(type: string): number {
    let maxAmount = 0;
    this.trendPoints(type).forEach((point: TrendPoint) => {
      if (point.amount > maxAmount) {
        maxAmount = point.amount;
      }
    });
    return maxAmount;
  }

  private trendBarHeight(amount: number, type: string): number {
    const maxAmount = this.maxTrendAmount(type);
    if (maxAmount <= 0) {
      return 8;
    }
    return Math.max(10, Math.round(amount / maxAmount * 96));
  }

  private largestRecordTitle(type: string): string {
    let title = '暂无记录';
    let amount = 0;
    this.records.forEach((item: BillRecord) => {
      if (item.type === type && item.amount > amount) {
        title = item.title;
        amount = item.amount;
      }
    });
    return title;
  }

  private largestRecordAmount(type: string): number {
    let amount = 0;
    this.records.forEach((item: BillRecord) => {
      if (item.type === type && item.amount > amount) {
        amount = item.amount;
      }
    });
    return amount;
  }

  private reportPrimaryColor(): string {
    return this.reportType === '支出' ? '#D46D62' : '#4E956C';
  }

  private budgetLeft(): number {
    return Math.max(this.monthlyBudget - this.expenseTotal(), 0);
  }

  private savingRate(): number {
    if (this.incomeTotal() <= 0) {
      return 0;
    }
    return Math.max(this.balance() / this.incomeTotal() * 100, 0);
  }

  private reportAdvice(): string {
    if (this.reportType === '收入') {
      if (this.incomeTotal() <= 0) {
        return '本月还没有收入记录，可以先补录工资、兼职或理财收益。';
      }
      return `当前结余率约${Math.round(this.savingRate())}%，建议把固定储蓄单独记为目标，避免结余被日常消费稀释。`;
    }

    const top = this.topCategoryStat('支出');
    if (this.expenseTotal() <= 0) {
      return '本月还没有支出记录，开始记第一笔后这里会生成可执行建议。';
    }
    if (this.budgetRate() >= 0.85) {
      return `预算已使用${Math.round(this.budgetRate() * 100)}%，建议优先压缩${top.name}类支出。`;
    }
    return `${top.name}占支出${Math.round(top.rate)}%，本月预算还剩¥${this.money(this.budgetLeft())}，节奏还算健康。`;
  }

  private saveRecord(): void {
    const amount = Number(this.amountText);
    if (!amount || amount <= 0) {
      return;
    }
    const title = this.noteText.trim().length > 0 ? this.noteText.trim() : this.selectedCategory;
    if (this.editingId > 0) {
      this.records = this.records.map((item: BillRecord) => {
        if (item.id === this.editingId) {
          return {
            id: item.id,
            type: this.recordType,
            category: this.selectedCategory,
            title: title,
            amount: amount,
            time: item.time
          };
        }
        return item;
      });
    } else {
      const newRecord: BillRecord = {
        id: this.nextId(),
        type: this.recordType,
        category: this.selectedCategory,
        title: title,
        amount: amount,
        time: '刚刚'
      };
      this.records = [newRecord].concat(this.records);
    }
    this.clearForm();
  }

  private clearForm(): void {
    this.amountText = '';
    this.noteText = '';
    this.aiText = '';
    this.editingId = -1;
    this.recordType = '支出';
    this.selectedCategory = '餐饮';
  }

  private editRecord(record: BillRecord): void {
    this.recordType = record.type;
    this.selectedCategory = record.category;
    this.amountText = `${record.amount}`;
    this.noteText = record.title;
    this.editingId = record.id;
    this.activeTab = 0;
  }

  private deleteRecord(id: number): void {
    this.records = this.records.filter((item: BillRecord) => item.id !== id);
  }

  private appendDigit(value: string): void {
    if (value === '.' && this.amountText.indexOf('.') >= 0) {
      return;
    }
    if (this.amountText.length >= 10) {
      return;
    }
    this.amountText += value;
  }

  private normalizeAmount(value: string): string {
    let result = '';
    let hasDot = false;
    for (let index = 0; index < value.length; index++) {
      const char = value.charAt(index);
      if (char >= '0' && char <= '9') {
        result += char;
      } else if (char === '.' && !hasDot) {
        result += char;
        hasDot = true;
      }
      if (result.length >= 10) {
        break;
      }
    }
    return result;
  }

  private parseAiText(): void {
    const text = this.aiText.trim();
    if (text.length === 0) {
      return;
    }
    const match = text.match(/\d+(\.\d+)?/);
    if (match) {
      this.amountText = match[0];
    }
    if (text.indexOf('工资') >= 0 || text.indexOf('收入') >= 0 || text.indexOf('兼职') >= 0) {
      this.recordType = '收入';
      this.selectedCategory = text.indexOf('兼职') >= 0 ? '兼职' : '工资';
    } else {
      this.recordType = '支出';
      if (text.indexOf('饭') >= 0 || text.indexOf('餐') >= 0 || text.indexOf('咖啡') >= 0 || text.indexOf('奶茶') >= 0) {
        this.selectedCategory = '餐饮';
      } else if (text.indexOf('地铁') >= 0 || text.indexOf('打车') >= 0 || text.indexOf('公交') >= 0) {
        this.selectedCategory = '交通';
      } else if (text.indexOf('买') >= 0 || text.indexOf('购物') >= 0) {
        this.selectedCategory = '购物';
      } else if (text.indexOf('电影') >= 0 || text.indexOf('游戏') >= 0) {
        this.selectedCategory = '娱乐';
      } else {
        this.selectedCategory = '其他';
      }
    }
    this.noteText = text.replace(/\d+(\.\d+)?/g, '').replace(/块|元|花了|今天/g, '').trim();
    if (this.noteText.length === 0) {
      this.noteText = this.selectedCategory;
    }
  }

  @Builder
  StatCard(label: string, value: string, color: string) {
    Column({ space: 3 }) {
      Text(label)
        .fontSize(10)
        .fontColor('#EAF2F5')
      Text(value)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')
        .maxLines(1)
    }
    .alignItems(HorizontalAlign.Start)
    .padding({ left: 12, right: 10, top: 11, bottom: 10 })
    .height(52)
    .borderRadius(16)
    .backgroundColor('#20FFFFFF')
    .layoutWeight(1)
  }

  @Builder
  SectionTitle(title: string, action: string = '') {
    Row() {
      Text(title)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1E252B')
      Blank()
      if (action.length > 0) {
        Text(action)
          .fontSize(12)
          .fontColor(this.currentTheme().primary)
      }
    }
    .width('100%')
    .margin({ top: 14, bottom: 8 })
  }

  @Builder
  Segment(label: string, value: string) {
    Text(label)
      .fontSize(14)
      .fontWeight(this.recordType === value ? FontWeight.Bold : FontWeight.Regular)
      .fontColor(this.recordType === value ? '#FFFFFF' : '#56616B')
      .textAlign(TextAlign.Center)
      .padding({ top: 7, bottom: 7 })
      .borderRadius(16)
      .backgroundColor(this.recordType === value ? this.currentTheme().primary : '#EEF1F2')
      .layoutWeight(1)
      .onClick(() => {
        this.recordType = value;
        this.selectedCategory = value === '支出' ? '餐饮' : '工资';
      })
  }

  @Builder
  CategoryGrid() {
    Grid() {
      ForEach(this.currentCategories(), (item: CategoryMeta) => {
        GridItem() {
          Column({ space: 7 }) {
            Text(item.name.substring(0, 1))
              .fontSize(13)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.selectedCategory === item.name ? '#FFFFFF' : item.color)
              .textAlign(TextAlign.Center)
              .width(32)
              .height(32)
              .borderRadius(16)
              .backgroundColor(this.selectedCategory === item.name ? item.color : '#F4F6F6')
            Text(item.name)
              .fontSize(11)
              .fontColor('#4A545D')
          }
          .width('100%')
          .onClick(() => {
            this.selectedCategory = item.name;
          })
        }
      }, (item: CategoryMeta) => item.name)
    }
    .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
    .rowsGap(10)
    .columnsGap(6)
    .height(this.recordType === '支出' ? 126 : 58)
  }

  @Builder
  KeyButton(value: string) {
    Button(value)
      .fontSize(15)
      .fontWeight(FontWeight.Medium)
      .fontColor('#222A30')
      .height(38)
      .borderRadius(12)
      .backgroundColor('#F3F6F6')
      .onClick(() => {
        if (value === '退格') {
          if (this.amountText.length > 0) {
            this.amountText = this.amountText.substring(0, this.amountText.length - 1);
          }
        } else if (value === '清空') {
          this.amountText = '';
        } else {
          this.appendDigit(value);
        }
      })
  }

  @Builder
  RecordRow(item: BillRecord) {
    Row({ space: 10 }) {
      Text(item.category.substring(0, 1))
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')
        .textAlign(TextAlign.Center)
        .width(36)
        .height(36)
        .borderRadius(18)
        .backgroundColor(this.categoryColor(item.category))
      Column({ space: 4 }) {
        Text(item.title)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1F272D')
          .maxLines(1)
        Text(`${item.category} · ${item.time}`)
          .fontSize(12)
          .fontColor('#7A838C')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      Text(`${item.type === '支出' ? '-' : '+'}${this.money(item.amount)}`)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor(item.type === '支出' ? '#D46D62' : '#4E956C')
      Button('编辑')
        .fontSize(12)
        .fontColor(this.currentTheme().primary)
        .height(30)
        .padding({ left: 8, right: 8 })
        .borderRadius(10)
        .backgroundColor(this.currentTheme().soft)
        .onClick(() => {
          this.editRecord(item);
        })
      Button('删')
        .fontSize(12)
        .fontColor('#D46D62')
        .height(30)
        .padding({ left: 8, right: 8 })
        .borderRadius(10)
        .backgroundColor('#F8E7E5')
        .onClick(() => {
          this.deleteRecord(item.id);
        })
    }
    .width('100%')
    .padding({ top: 10, bottom: 10 })
    .border({ width: { bottom: 1 }, color: '#EEF0F1' })
  }

  @Builder
  ReportTypeButton(label: string) {
    Text(label)
      .fontSize(13)
      .fontWeight(this.reportType === label ? FontWeight.Bold : FontWeight.Regular)
      .fontColor(this.reportType === label ? '#FFFFFF' : '#56616B')
      .textAlign(TextAlign.Center)
      .height(32)
      .padding({ left: 18, right: 18 })
      .borderRadius(16)
      .backgroundColor(this.reportType === label ? this.reportPrimaryColor() : '#EEF1F2')
      .onClick(() => {
        this.reportType = label;
      })
  }

  @Builder
  ReportMetricCard(label: string, value: string, hint: string, color: string) {
    Column({ space: 5 }) {
      Text(label)
        .fontSize(11)
        .fontColor('#7A838C')
      Text(value)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)
        .maxLines(1)
      Text(hint)
        .fontSize(10)
        .fontColor('#8A929A')
        .maxLines(1)
    }
    .alignItems(HorizontalAlign.Start)
    .padding(12)
    .height(82)
    .borderRadius(16)
    .backgroundColor('#F7F9F9')
    .layoutWeight(1)
  }

  @Builder
  TrendChart() {
    Column({ space: 12 }) {
      Row() {
        Column({ space: 4 }) {
          Text(`${this.reportType}趋势`)
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1E252B')
          Text('按账单时间自动汇总')
            .fontSize(12)
            .fontColor('#7A838C')
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
        Text(`¥${this.money(this.totalByType(this.reportType))}`)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.reportPrimaryColor())
      }
      Row({ space: 8 }) {
        ForEach(this.trendPoints(this.reportType), (point: TrendPoint) => {
          Column({ space: 7 }) {
            Text(point.amount > 0 ? this.money(point.amount) : '-')
              .fontSize(9)
              .fontColor('#7A838C')
              .maxLines(1)
            Column() {
              Blank()
              Column()
                .height(this.trendBarHeight(point.amount, this.reportType))
                .width('100%')
                .borderRadius(8)
                .backgroundColor(point.amount > 0 ? this.reportPrimaryColor() : '#E8ECEE')
            }
            .height(104)
            .width('100%')
            Text(point.label)
              .fontSize(10)
              .fontColor(point.count > 0 ? '#2C343B' : '#9AA1A8')
              .maxLines(1)
          }
          .layoutWeight(1)
        }, (point: TrendPoint) => point.label)
      }
    }
    .width('100%')
    .padding(16)
    .borderRadius(22)
    .backgroundColor('#FFFFFF')
    .shadow({ radius: 12, color: '#0C4F5B61', offsetX: 0, offsetY: 5 })
  }

  @Builder
  CategoryRank() {
    Column({ space: 12 }) {
      if (this.categoryStats(this.reportType).length === 0) {
        Text(`暂无${this.reportType}分类数据`)
          .fontSize(13)
          .fontColor('#7A838C')
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding({ top: 18, bottom: 18 })
      } else {
        ForEach(this.categoryStats(this.reportType), (item: CategoryStat) => {
          Column({ space: 8 }) {
            Row({ space: 10 }) {
              Text(item.name.substring(0, 1))
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .textAlign(TextAlign.Center)
                .width(28)
                .height(28)
                .borderRadius(14)
                .backgroundColor(item.color)
              Column({ space: 3 }) {
                Row() {
                  Text(item.name)
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#2C343B')
                  Blank()
                  Text(`${Math.round(item.rate)}%`)
                    .fontSize(12)
                    .fontColor('#7A838C')
                }
                Text(`${item.count}笔 · ¥${this.money(item.total)}`)
                  .fontSize(11)
                  .fontColor('#8A929A')
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
            }
            Progress({ value: item.rate, total: 100, type: ProgressType.Linear })
              .color(item.color)
              .backgroundColor('#EDF0F1')
              .height(7)
          }
        }, (item: CategoryStat) => item.name)
      }
    }
    .width('100%')
    .padding(16)
    .borderRadius(22)
    .backgroundColor('#FFFFFF')
  }

  @Builder
  InsightPanel() {
    Column({ space: 12 }) {
      Row({ space: 10 }) {
        Text('建议')
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .textAlign(TextAlign.Center)
          .width(42)
          .height(28)
          .borderRadius(14)
          .backgroundColor(this.currentTheme().primary)
        Text(this.reportAdvice())
          .fontSize(14)
          .fontColor('#2C343B')
          .layoutWeight(1)
      }
      Row({ space: 10 }) {
        this.ReportMetricCard('最高分类', this.topCategoryStat(this.reportType).name, `¥${this.money(this.topCategoryStat(this.reportType).total)}`, this.topCategoryStat(this.reportType).color)
        this.ReportMetricCard('最大单笔', `¥${this.money(this.largestRecordAmount(this.reportType))}`, this.largestRecordTitle(this.reportType), this.reportPrimaryColor())
      }
    }
    .width('100%')
    .padding(16)
    .borderRadius(22)
    .backgroundColor(this.currentTheme().soft)
  }

  @Builder
  HomePage() {
    Scroll() {
      Column() {
        Column({ space: 14 }) {
          Row() {
            Column({ space: 6 }) {
              Text('简账')
                .fontSize(21)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
              Text('让每一笔钱都清清楚楚')
                .fontSize(11)
                .fontColor('#EAF2F5')
            }
            .alignItems(HorizontalAlign.Start)
            Blank()
            Text(THEMES[this.themeIndex].name)
              .fontSize(11)
              .fontColor('#FFFFFF')
              .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              .borderRadius(16)
              .backgroundColor('#26FFFFFF')
          }
          .width('100%')
          Row({ space: 10 }) {
            this.StatCard('本月支出', `¥${this.money(this.expenseTotal())}`, '#D46D62')
            this.StatCard('本月收入', `¥${this.money(this.incomeTotal())}`, '#4E956C')
            this.StatCard('结余', `¥${this.money(this.balance())}`, '#2E596F')
          }
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 16, bottom: 16 })
        .borderRadius(22)
        .linearGradient({
          angle: 135,
          colors: [[this.currentTheme().primary, 0], ['#7E9C9A', 1]]
        })

        this.SectionTitle(this.editingId > 0 ? '编辑账单' : '快捷记账', 'AI识别')
        Column({ space: 10 }) {
          TextInput({ placeholder: '试试：今天午饭花了35块', text: this.aiText })
            .height(36)
            .fontSize(12)
            .borderRadius(16)
            .backgroundColor('#F5F7F7')
            .onChange((value: string) => {
              this.aiText = value;
            })
          Row({ space: 10 }) {
            Button('识别账单')
              .fontSize(12)
              .fontColor('#FFFFFF')
              .height(34)
              .borderRadius(16)
              .backgroundColor(this.currentTheme().primary)
              .layoutWeight(1)
              .onClick(() => {
                this.parseAiText();
              })
            Button(this.editingId > 0 ? '取消编辑' : '重置')
              .fontSize(12)
              .fontColor('#56616B')
              .height(34)
              .borderRadius(16)
              .backgroundColor('#EEF1F2')
              .layoutWeight(1)
              .onClick(() => {
                this.clearForm();
              })
          }
          Row({ space: 8 }) {
            this.Segment('支出', '支出')
            this.Segment('收入', '收入')
          }
          Row() {
            Text('¥')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#56616B')
            TextInput({ placeholder: '0', text: this.amountText })
              .fontSize(26)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1E252B')
              .placeholderColor('#1E252B')
              .backgroundColor('#00FFFFFF')
              .padding({ left: 4, right: 4 })
              .onChange((value: string) => {
                this.amountText = this.normalizeAmount(value);
              })
              .layoutWeight(1)
          }
          .width('100%')
          .padding({ left: 12, right: 12, top: 8, bottom: 8 })
          .borderRadius(18)
          .backgroundColor('#F7F9F9')
          this.CategoryGrid()
          TextInput({ placeholder: '备注，例如：午饭、奶茶、工资', text: this.noteText })
            .height(36)
            .fontSize(12)
            .borderRadius(16)
            .backgroundColor('#F5F7F7')
            .onChange((value: string) => {
              this.noteText = value;
            })
          Row({ space: 10 }) {
            Button('清空')
              .fontSize(12)
              .fontColor('#56616B')
              .height(38)
              .borderRadius(16)
              .backgroundColor('#EEF1F2')
              .layoutWeight(1)
              .onClick(() => {
                this.amountText = '';
              })
            Button(this.editingId > 0 ? '保存修改' : '完成记账')
              .fontSize(13)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .height(38)
              .borderRadius(16)
              .backgroundColor(this.currentTheme().primary)
              .layoutWeight(2)
              .onClick(() => {
                this.saveRecord();
              })
          }
        }
        .width('100%')
        .padding(14)
        .borderRadius(22)
        .backgroundColor('#FFFFFF')
        .shadow({ radius: 14, color: '#0F4F5B61', offsetX: 0, offsetY: 6 })

        this.SectionTitle('最近账单', `${this.records.length}笔`)
        Column() {
          ForEach(this.records, (item: BillRecord) => {
            this.RecordRow(item)
          }, (item: BillRecord) => `${item.id}`)
        }
        .width('100%')
        .padding({ left: 14, right: 14 })
        .borderRadius(22)
        .backgroundColor('#FFFFFF')
      }
      .width('100%')
      .padding({ left: 14, right: 14, top: 12, bottom: 90 })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  ReportsPage() {
    Scroll() {
      Column() {
        this.SectionTitle('统计报表', '实时')
        Row({ space: 10 }) {
          this.ReportTypeButton('支出')
          this.ReportTypeButton('收入')
          Blank()
        }
        .width('100%')
        .margin({ bottom: 12 })

        Row({ space: 10 }) {
          this.ReportMetricCard(`${this.reportType}总额`, `¥${this.money(this.totalByType(this.reportType))}`, `${this.countByType(this.reportType)}笔记录`, this.reportPrimaryColor())
          this.ReportMetricCard('单笔均值', `¥${this.money(this.averageByType(this.reportType))}`, '用于判断日常强度', this.currentTheme().primary)
        }
        .width('100%')
        .margin({ bottom: 12 })

        Row({ space: 10 }) {
          this.ReportMetricCard('本月结余', `¥${this.money(this.balance())}`, `结余率${Math.round(this.savingRate())}%`, this.balance() >= 0 ? '#4E956C' : '#D46D62')
          this.ReportMetricCard('预算剩余', `¥${this.money(this.budgetLeft())}`, `已用${Math.round(this.budgetRate() * 100)}%`, this.budgetRate() >= 0.85 ? '#D46D62' : this.currentTheme().primary)
        }
        .width('100%')

        this.SectionTitle('趋势')
        this.TrendChart()

        this.SectionTitle('分类排行', `${this.categoryStats(this.reportType).length}类`)
        this.CategoryRank()

        this.SectionTitle('洞察')
        this.InsightPanel()
      }
      .width('100%')
      .padding({ left: 14, right: 14, top: 12, bottom: 90 })
    }
  }

  @Builder
  BudgetPage() {
    Scroll() {
      Column() {
        this.SectionTitle('预算中心')
        Column({ space: 18 }) {
          Text('月度预算')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .width('100%')
          Row() {
            Text(`¥${this.money(this.monthlyBudget)}`)
              .fontSize(30)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1E252B')
            Blank()
            Text(`已用${Math.round(this.budgetRate() * 100)}%`)
              .fontSize(13)
              .fontColor(this.budgetRate() > 0.85 ? '#D46D62' : this.currentTheme().primary)
              .padding({ left: 12, right: 12, top: 7, bottom: 7 })
              .borderRadius(16)
              .backgroundColor(this.budgetRate() > 0.85 ? '#F8E7E5' : this.currentTheme().soft)
          }
          Progress({ value: this.budgetRate() * 100, total: 100, type: ProgressType.Linear })
            .color(this.budgetRate() > 0.85 ? '#D46D62' : this.currentTheme().primary)
            .backgroundColor('#EDF0F1')
            .height(12)
          Row({ space: 10 }) {
            Button('-100')
              .height(40)
              .borderRadius(12)
              .backgroundColor('#EEF1F2')
              .fontColor('#56616B')
              .layoutWeight(1)
              .onClick(() => {
                this.monthlyBudget = Math.max(500, this.monthlyBudget - 100);
              })
            Button('+100')
              .height(40)
              .borderRadius(12)
              .backgroundColor(this.currentTheme().primary)
              .fontColor('#FFFFFF')
              .layoutWeight(1)
              .onClick(() => {
                this.monthlyBudget += 100;
              })
          }
        }
        .width('100%')
        .padding(18)
        .borderRadius(22)
        .backgroundColor('#FFFFFF')
        .shadow({ radius: 12, color: '#0C4F5B61', offsetX: 0, offsetY: 5 })

        this.SectionTitle('挑战赛')
        Row({ space: 12 }) {
          this.ChallengeCard('克制新星', '预算使用低于80%', this.budgetRate() < 0.8)
          this.ChallengeCard('连续记账', '本月已记录7天', true)
        }
        Row({ space: 12 }) {
          this.ChallengeCard('少点外卖', '餐饮支出下降10%', false)
          this.ChallengeCard('结余守护', '保持正结余', this.balance() > 0)
        }
        .margin({ top: 12 })
      }
      .width('100%')
      .padding({ left: 14, right: 14, top: 12, bottom: 90 })
    }
  }

  @Builder
  ChallengeCard(title: string, desc: string, unlocked: boolean) {
    Column({ space: 8 }) {
      Text(unlocked ? '已解锁' : '挑战中')
        .fontSize(12)
        .fontColor(unlocked ? '#4E956C' : '#8A8F98')
        .padding({ left: 10, right: 10, top: 5, bottom: 5 })
        .borderRadius(12)
        .backgroundColor(unlocked ? '#E7F2EE' : '#EEF1F2')
      Text(title)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1E252B')
      Text(desc)
        .fontSize(12)
        .fontColor('#687078')
        .textAlign(TextAlign.Center)
    }
    .justifyContent(FlexAlign.Center)
    .height(122)
    .layoutWeight(1)
    .padding(12)
    .borderRadius(22)
    .backgroundColor('#FFFFFF')
  }

  @Builder
  ProfilePage() {
    Scroll() {
      Column() {
        this.SectionTitle('个人中心')
        Column({ space: 12 }) {
          Text('简账默认账本')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1E252B')
            .width('100%')
          Text('本地优先保存，云备份需授权后开启。')
            .fontSize(13)
            .fontColor('#687078')
            .width('100%')
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        .padding(18)
        .borderRadius(22)
        .backgroundColor('#FFFFFF')

        this.SectionTitle('动态主题')
        Column({ space: 10 }) {
          ForEach(THEMES, (item: ThemeMeta, index: number) => {
            Row({ space: 12 }) {
              Column()
                .width(28)
                .height(28)
                .borderRadius(14)
                .backgroundColor(item.primary)
              Text(item.name)
                .fontSize(15)
                .fontWeight(this.themeIndex === index ? FontWeight.Bold : FontWeight.Regular)
                .fontColor('#2C343B')
                .layoutWeight(1)
              Text(this.themeIndex === index ? '使用中' : '切换')
                .fontSize(13)
                .fontColor(this.themeIndex === index ? '#4E956C' : this.currentTheme().primary)
            }
            .padding(14)
            .borderRadius(18)
            .backgroundColor(this.themeIndex === index ? item.soft : '#FFFFFF')
            .onClick(() => {
              this.themeIndex = index;
            })
          }, (item: ThemeMeta) => item.name)
        }

        this.SectionTitle('隐私与备份')
        Column() {
          this.SettingRow('数据库加密', '已开启本地加密')
          this.SettingRow('云备份', '待授权')
          this.SettingRow('导出数据', 'CSV / PDF')
          this.SettingRow('广告SDK', '未接入')
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
        .borderRadius(22)
        .backgroundColor('#FFFFFF')
      }
      .width('100%')
      .padding({ left: 14, right: 14, top: 12, bottom: 90 })
    }
  }

  @Builder
  SettingRow(title: string, value: string) {
    Row() {
      Text(title)
        .fontSize(14)
        .fontColor('#2C343B')
      Blank()
      Text(value)
        .fontSize(12)
        .fontColor('#7A838C')
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
    .border({ width: { bottom: 1 }, color: '#EEF0F1' })
  }

  @Builder
  TabItem(title: string, index: number) {
    Column({ space: 4 }) {
      Text(title)
        .fontSize(12)
        .fontWeight(this.activeTab === index ? FontWeight.Bold : FontWeight.Regular)
        .fontColor(this.activeTab === index ? this.currentTheme().primary : '#7A838C')
      Column()
        .width(16)
        .height(3)
        .borderRadius(2)
        .backgroundColor(this.activeTab === index ? this.currentTheme().primary : '#00FFFFFF')
    }
    .height(50)
    .justifyContent(FlexAlign.Center)
    .layoutWeight(1)
    .onClick(() => {
      this.activeTab = index;
    })
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        if (this.activeTab === 0) {
          this.HomePage()
        } else if (this.activeTab === 1) {
          this.ReportsPage()
        } else if (this.activeTab === 2) {
          this.BudgetPage()
        } else {
          this.ProfilePage()
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.currentTheme().surface)

      Row() {
        this.TabItem('记账', 0)
        this.TabItem('统计', 1)
        this.TabItem('预算', 2)
        this.TabItem('我的', 3)
      }
      .width('88%')
      .height(54)
      .margin({ bottom: 10 })
      .padding({ left: 8, right: 8 })
      .borderRadius(20)
      .backgroundColor('#FFFFFF')
      .shadow({ radius: 16, color: '#1A000000', offsetX: 0, offsetY: 7 })
    }
    .width('100%')
    .height('100%')
  }
}
