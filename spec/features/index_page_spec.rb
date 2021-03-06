RSpec.describe '/content' do
  include GdsApi::TestHelpers::ContentDataApi
  include TableDataSpecHelpers
  let(:metrics) { %w[pviews upviews searches feedex words pdf_count satisfaction useful_yes useful_no] }
  let(:from) { Time.zone.today.last_month.beginning_of_month.to_s('%F') }
  let(:to) { Time.zone.today.last_month.end_of_month.to_s('%F') }
  let(:items) do
    [
      {
        base_path: '/path/1',
        title: 'The title',
        upviews: 233_018,
        document_type: 'news_story',
        satisfaction: 0.81301,
        satisfaction_responses: 250,
        searches: 220
      },
      {
        base_path: '/path/2',
        title: 'Another title',
        upviews: 100_018,
        document_type: 'guide',
        satisfaction: 0.68,
        satisfaction_responses: 42,
        searches: 12
      }
    ]
  end

  before do
    stub_metrics_page(base_path: 'path/1', time_period: :last_month)
    content_data_api_has_content_items(from: from, to: to, organisation_id: 'org-id', items: items)
    content_data_has_orgs
    GDS::SSO.test_user = build(:user)
    visit "/content?date_range=last-month&organisation_id=org-id"
  end

  it 'renders the page without error' do
    expect(page.status_code).to eq(200)
    expect(page).to have_content('Content data')
  end

  it 'renders the data in a table' do
    table_rows = extract_table_content('.content-table table')
    expect(table_rows).to eq(
      [
        ['Page title', 'Content type', 'Unique pageviews', 'User satisfaction score', 'Searches from page'],
        ['The title /path/1', 'News story', '233,018', '81.3% (250 responses)', '220'],
        ['Another title /path/2', 'Guide', '100,018', '68.0% (42 responses)', '12'],
      ]
    )
  end

  context 'click title of an item' do
    it 'takes you to single content item page' do
      click_link 'The title'
      expect(current_path).to eq '/metrics/path/1'
    end

    it 'respects the date filter' do
      from = (Time.zone.today - 1.year).to_s('%F')
      to = Time.zone.today.to_s('%F')
      stub_metrics_page(base_path: 'path/1', time_period: :last_year)
      content_data_api_has_content_items(from: from, to: to, organisation_id: 'org-id', items: items)

      visit "/content?date_range=last-year&organisation_id=org-id"
      click_link 'The title'
      expect(current_path).to eq '/metrics/path/1'
      expect(page).to have_content("Page data: #{I18n.t('metrics.show.time_periods.last-year.leading')}")
    end
  end

  context 'filter by organisation' do
    before do
      content_data_api_has_content_items(from: from, to: to, organisation_id: 'another-org-id', items: items)
      select 'another org', from: 'organisation_id'
      click_on 'Filter'
    end

    it 'makes request to api with correct organisation_id' do
      expect(page).to have_content('Content data')
    end

    it 'links to the page data page after filtering' do
      click_on 'The title'
      expect(page).to have_content("Page data: #{I18n.t('metrics.show.time_periods.last-month.leading')}")
    end

    it 'selected organisation is shown in dropdown menu' do
      expect(page).to have_select('organisation_id', text: 'another org')
    end

    it 'respects date range' do
      from = (Time.zone.today - 1.year).to_s('%F')
      to = Time.zone.today.to_s('%F')
      stub_metrics_page(base_path: 'path/1', time_period: :last_year)
      content_data_api_has_content_items(from: from, to: to, organisation_id: 'another-org-id', items: items)

      visit "/content?date_range=last-year&organisation_id=another-org-id"

      select 'another org', from: 'organisation_id'
      click_on 'Filter'
      click_on 'The title'
      expect(page).to have_content("Page data: #{I18n.t('metrics.show.time_periods.last-year.leading')}")
    end
  end
end
