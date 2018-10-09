RSpec.describe DateRange do
  describe '#to' do
    it 'returns today`s date if selected time period is `last-30-days`' do
      expect(DateRange.new('last-30-days').to).to eq(Time.zone.today.to_s)
    end
    it 'returns today`s date if selected time period is `last-3-months`' do
      expect(DateRange.new('last-3-months').to).to eq(Time.zone.today.to_s)
    end
    it 'returns today`s date if selected time period is `last-6-months`' do
      expect(DateRange.new('last-6-months').to).to eq(Time.zone.today.to_s)
    end
    it 'returns today`s date if selected time period is `last-year`' do
      expect(DateRange.new('last-year').to).to eq(Time.zone.today.to_s)
    end
    it 'returns today`s date if selected time period is `last-2-years`' do
      expect(DateRange.new('last-2-years').to).to eq(Time.zone.today.to_s)
    end
    it 'returns date of last day of previous month if selected time period is `last-month`' do
      expect(DateRange.new('last-month').to).to eq(Time.zone.today.last_month.end_of_month.to_s)
    end
  end
  describe '#from' do
    it 'returns date of 30 days ago if selected time period is `last-30-days`' do
      expect(DateRange.new('last-30-days').from).to eq((Time.zone.today - 30.days).to_s)
    end
    it 'returns date of 3 months ago if selected time period is `last-3-months`' do
      expect(DateRange.new('last-3-months').from).to eq((Time.zone.today - 3.months).to_s)
    end
    it 'returns date of 6 months ago if selected time period is `last-6-months`' do
      expect(DateRange.new('last-6-months').from).to eq((Time.zone.today - 6.months).to_s)
    end
    it 'returns date of 1 year ago if selected time period is `last-year`' do
      expect(DateRange.new('last-year').from).to eq((Time.zone.today - 1.year).to_s)
    end
    it 'returns date of 2 years ago if selected time period is `last-2-years`' do
      expect(DateRange.new('last-2-years').from).to eq((Time.zone.today - 2.years).to_s)
    end
    it 'returns date of first day of previous month if selected time period is `last-month`' do
      expect(DateRange.new('last-month').from).to eq(Time.zone.today.last_month.beginning_of_month.to_s)
    end
  end
  describe '#prev_to' do
    it 'returns date of 30 days ago if selected time period is `last-30-days`' do
      expect(DateRange.new('last-30-days').prev_to).to eq((Time.zone.today - 30.days).to_s)
    end
    it 'returns date of 3 months ago if selected time period is `last-3-months`' do
      expect(DateRange.new('last-3-months').prev_to).to eq((Time.zone.today - 3.months).to_s)
    end
    it 'returns date of 6 months ago if selected time period is `last-6-months`' do
      expect(DateRange.new('last-6-months').prev_to).to eq((Time.zone.today - 6.months).to_s)
    end
    it 'returns date of 1 year ago if selected time period is `last-year`' do
      expect(DateRange.new('last-year').prev_to).to eq((Time.zone.today - 1.year).to_s)
    end
    it 'returns date of 2 years ago if selected time period is `last-2-years`' do
      expect(DateRange.new('last-2-years').prev_to).to eq((Time.zone.today - 2.years).to_s)
    end
    it 'returns date of last day of 2 months ago if selected time period is `last-month`' do
      expect(DateRange.new('last-month').prev_to).to eq((Time.zone.today - 2.months).end_of_month.to_s)
    end
  end
  describe '#prev_from' do
    it 'returns date of 60 days ago if selected time period is `last-30-days`' do
      expect(DateRange.new('last-30-days').prev_from).to eq((Time.zone.today - 60.days).to_s)
    end
    it 'returns date of 6 months ago if selected time period is `last-3-months`' do
      expect(DateRange.new('last-3-months').prev_from).to eq((Time.zone.today - 6.months).to_s)
    end
    it 'returns date of 12 months ago if selected time period is `last-6-months`' do
      expect(DateRange.new('last-6-months').prev_from).to eq((Time.zone.today - 12.months).to_s)
    end
    it 'returns date of 2 year ago if selected time period is `last-year`' do
      expect(DateRange.new('last-year').prev_from).to eq((Time.zone.today - 2.years).to_s)
    end
    it 'returns date of 5 years ago if selected time period is `last-2-years`' do
      expect(DateRange.new('last-2-years').prev_from).to eq((Time.zone.today - 4.years).to_s)
    end
    it 'returns date of first day of 2 months ago if selected time period is `last-month`' do
      expect(DateRange.new('last-month').prev_from).to eq((Time.zone.today - 2.months).beginning_of_month.to_s)
    end
  end
end
