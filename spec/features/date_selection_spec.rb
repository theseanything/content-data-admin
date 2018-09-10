RSpec.describe 'date selection', type: :feature do
  include GdsApi::TestHelpers::ContentDataApi

  before do
    initial_page_stub
  end

  it 'renders data for the last 30 days if no date period is selected' do
    to = Time.zone.today
    from = Time.zone.today - 30.days
    visit '/metrics/base/path?metrics[]=unique_pageviews&metrics[]=pageviews'

    expect_default_date_period_metrics_to_be_displayed(from, to)
  end

  it 'renders data for the last 30 days when `last 30 days` is selected' do
    to = Time.zone.today
    from = Time.zone.today - 30.days
    stub_for(from, to)

    visit '/metrics/base/path?metrics[]=unique_pageviews&metrics[]=pageviews'
    find('#date_range_last-30-days').click
    click_button 'OK'
    sleep 2
    click_on 'Unique pageviews table'

    expect_metrics_for_each_date_to_be_correct(from, to)
  end

  it 'renders data for the previous month when `last month` is selected' do
    to = Time.zone.today.last_month.end_of_month
    from = Time.zone.today.last_month.beginning_of_month
    stub_for(from, to)

    visit '/metrics/base/path?metrics[]=unique_pageviews&metrics[]=pageviews'
    find('#date_range_last-month').click
    click_button 'OK'
    sleep 2
    click_on 'Unique pageviews table'

    expect_metrics_for_each_date_to_be_correct(from, to)
  end

  it 'renders data for the last 3 months when `last 3 months` is selected' do
    to = Time.zone.today
    from = Time.zone.today - 3.months
    stub_for(from, to)

    visit '/metrics/base/path?metrics[]=unique_pageviews&metrics[]=pageviews'
    find('#date_range_last-3-months').click
    click_button 'OK'
    click_on 'Unique pageviews table'

    expect_metrics_for_each_date_to_be_correct(from, to)
  end

  it 'renders data for the last 6 months when `last6 months` is selected' do
    to = Time.zone.today
    from = Time.zone.today - 6.months
    stub_for(from, to)

    visit '/metrics/base/path?metrics[]=unique_pageviews&metrics[]=pageviews'
    find('#date_range_last-6-months').click
    click_button 'OK'
    click_on 'Unique pageviews table'

    expect_metrics_for_each_date_to_be_correct(from, to)
  end

  it 'renders data for the last year when `last year` is selected' do
    to = Time.zone.today
    from = Time.zone.today - 1.year
    stub_for(from, to)

    visit '/metrics/base/path?metrics[]=unique_pageviews&metrics[]=pageviews'
    find('#date_range_last-1-year').click
    click_button 'OK'
    sleep 2
    click_on 'Unique pageviews table'

    expect_metrics_for_each_date_to_be_correct(from, to)
  end

  it 'renders data for the last 2 years when `last 2 years` is selected' do
    to = Time.zone.today
    from = Time.zone.today - 2.years
    stub_for(from, to)

    visit '/metrics/base/path?metrics[]=unique_pageviews&metrics[]=pageviews'
    find('#date_range_last-2-years').click
    click_button 'OK'
    click_on 'Unique pageviews table'

    expect_metrics_for_each_date_to_be_correct(from, to)
  end

  def initial_page_stub
    from = Time.zone.today - 30.days
    to = Time.zone.today

    content_data_api_has_metric(base_path: 'base/path',
      from: from,
      to: to,
      metrics: %w[unique_pageviews pageviews number_of_internal_searches],
      payload: {
        base_path: '/base/path',
        unique_pageviews: 145_000,
        pageviews: 200_000,
        title: "Content Title",
        first_published_at: '2018-02-01T00:00:00.000Z',
        public_updated_at: '2018-04-25T00:00:00.000Z',
        primary_organisation_title: 'The ministry',
        document_type: "news_story"
      })

    content_data_api_has_timeseries(base_path: 'base/path',
      from: from,
      to: to,
      metrics: %w[unique_pageviews pageviews number_of_internal_searches],
      payload: {
        unique_pageviews: [
          { "date" => (from - 1.day).to_s, "value" => 0 },
          { "date" => (from - 2.days).to_s, "value" => 9 },
          { "date" => (to + 1.day).to_s, "value" => 9 }
        ],
        pageviews: [
          { "date" => (from - 1.day).to_s, "value" => 8 },
          { "date" => (from - 2.days).to_s, "value" => 8 },
          { "date" => (to + 1.day).to_s, "value" => 8 }
        ]
      })
  end

  def stub_for(from, to)
    content_data_api_has_metric(base_path: 'base/path',
      from: from,
      to: to,
      metrics: %w[unique_pageviews pageviews number_of_internal_searches],
      payload: {
        base_path: '/base/path',
        unique_pageviews: 145_000,
        pageviews: 200_000,
        title: "Content Title",
        first_published_at: '2018-02-01T00:00:00.000Z',
        public_updated_at: '2018-04-25T00:00:00.000Z',
        primary_organisation_title: 'The ministry',
        document_type: "news_story"
      })

    content_data_api_has_timeseries(base_path: 'base/path',
      from: from,
      to: to,
      metrics: %w[unique_pageviews pageviews number_of_internal_searches],
      payload: {
        unique_pageviews: [
          { "date" => (from - 1.day).to_s, "value" => 1 },
          { "date" => (from - 2.days).to_s, "value" => 2 },
          { "date" => (to + 1.day).to_s, "value" => 30 }
        ],
        pageviews: [
          { "date" => (from - 1.day).to_s, "value" => 10 },
          { "date" => (from - 2.days).to_s, "value" => 20 },
          { "date" => (to + 1.day).to_s, "value" => 30 }
        ]
      })
  end

  def expect_metrics_for_each_date_to_be_correct(from, to)
    date1 = (from - 1.day).to_s.last(5)
    date2 = (from - 2.days).to_s.last(5)
    date3 = (to + 1.day).to_s.last(5)

    unique_pageviews_rows = find("#unique_pageviews_table").all('tr')

    expect(unique_pageviews_rows.count).to eq 4
    expect(unique_pageviews_rows[0].text).to eq ""
    expect(unique_pageviews_rows[1].text).to eq "#{date1} 1"
    expect(unique_pageviews_rows[2].text).to eq "#{date2} 2"
    expect(unique_pageviews_rows[3].text).to eq "#{date3} 30"
  end

  def expect_default_date_period_metrics_to_be_displayed(from, to)
    date1 = (from - 1.day).to_s.last(5)
    date2 = (from - 2.days).to_s.last(5)
    date3 = (to + 1.day).to_s.last(5)

    unique_pageviews_rows = find("#unique_pageviews_table").all('tr')

    expect(unique_pageviews_rows.count).to eq 4
    expect(unique_pageviews_rows[0].text).to eq ""
    expect(unique_pageviews_rows[1].text).to eq "#{date1} 0"
    expect(unique_pageviews_rows[2].text).to eq "#{date2} 9"
    expect(unique_pageviews_rows[3].text).to eq "#{date3} 9"
  end
end
