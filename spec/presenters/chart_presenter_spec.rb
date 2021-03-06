RSpec.describe ChartPresenter do
  include ActiveSupport::Testing::TimeHelpers

  let(:date_range) { build :date_range, :last_30_days }

  around do |example|
    Timecop.freeze Date.new(2018, 1, 31) do
      example.run
    end
  end

  subject do
    ChartPresenter.new(
      json:
        [
          { date: '2018-01-13', value: 101 },
          { date: '2018-01-14', value: 202 },
          { date: '2018-01-15', value: 303 }
        ],
      metric: :upviews,
      date_range: date_range,
    )
  end

  it 'returns start date' do
    expect(subject.from).to eq '2018-01-01'
  end
  it 'returns end date' do
    expect(subject.to).to eq '2018-01-31'
  end

  it 'returns the correct message for no data' do
    expect(subject.no_data_message).to eq 'No Unique pageviews data for the selected time period'
  end

  it 'returns formatted hash of chart data' do
    expect(subject.chart_data).to eq upviews_chart_data
  end

  def upviews_chart_data
    {
      caption: "Unique pageviews from 2018-01-01 to 2018-01-31",
      chart_id: "upviews_chart",
      chart_label: "Unique pageviews",
      keys: [
        "01-13",
        "01-14",
        "01-15"
      ],

      rows: [
        {
          label: "Unique pageviews ",
          values: [
            101,
            202,
            303
          ]
        }
      ],
      table_id: "upviews_table",
      table_direction: "vertical"
    }
  end
end
