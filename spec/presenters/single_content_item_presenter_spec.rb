RSpec.describe SingleContentItemPresenter do
  include GdsApi::TestHelpers::ContentDataApi

  let(:from) { '2018-01-01' }
  let(:to) { '2018-06-01' }

  let(:metrics) do
    {
        title: 'The title',
        base_path: '/the/base/path',
        primary_organisation_title: 'UK Visas and Immigration',
        first_published_at: '2016-09-01T00:00:00.000Z',
        public_updated_at: '2017-10-01T00:00:00.000Z',
        document_type: 'news_story',
        upviews: 2030,
        pviews: 3000,
        satisfaction: 33.5,
        searches: 120,
        feedex: 20,
    }
  end
  let(:single_page_data) { default_single_page_payload('/the/base/path', from, to) }
  let(:date_range) { build(:date_range, :last_30_days) }

  subject do
    SingleContentItemPresenter.new(single_page_data, date_range)
  end


  describe '#publishing_app' do
    it 'does not fail if no publishing app' do
      single_page_data[:metadata][:publishing_app] = nil

      expect(subject.publishing_app).to eq('Unknown')
    end
    
    it 'capitalizes the publishing_app if present' do
      expect(subject.publishing_app).to eq('Publisher')
    end
  end

  describe '#metadata' do
    it 'returns a hash with the metadata' do
      expect(subject.metadata).to eq(
        base_path: '/the/base/path',
        published_at:  "17 July 2018",
        last_updated:  "17 July 2018",
        document_type:  "News story",
        publishing_organisation:  "The Ministry"
      )
    end
  end

  it 'returns the title' do
    expect(subject.title).to eq('Content Title')
  end
end
