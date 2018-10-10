class SingleContentItemPresenter
  include MetricsFormatterHelper

  attr_reader :date_range,
              :metadata,
              :feedex_series,
              :searches_series,
              :pviews_series,
              :satisfaction_series,
              :title,
              :upviews_series,
              :pdf_count,
              :words

  def initialize(single_page_data, date_range)
    @single_page_data = single_page_data
    @date_range = date_range
    @metrics = {}
    # @chart_metric_names = ['pviews', 'upviews', 'satisfaction', 'searches', 'feedex']
    # @glance_metric_names = ['upviews', 'satisfaction', 'searches', 'feedex']
    # @metrics = metrics
    get_metadata
    parse_metrics
    parse_time_series
    add_glance_metric_presenters
  end

  def publishing_app
    publishing_app = @single_page_data[:metadata][:publishing_app]

    publishing_app.present? ? publishing_app.capitalize.tr('-', ' ') : 'Unknown'
  end

private

  def get_metadata
    metadata = @single_page_data[:metadata]
    @title = metadata[:title]
    @metadata = {
      base_path: metadata[:base_path],
      document_type: metadata[:document_type].tr('_', ' ').capitalize,
      published_at: format_date(metadata[:first_published_at]),
      last_updated: format_date(metadata[:public_updated_at]),
      publishing_organisation: metadata[:primary_organisation_title],
    }
  end

  def parse_metrics
    @single_page_data[:time_series_metrics].each do |metric|
      @metrics[metric[:name]] = {
        'value': format_metric_value(metric[:name], metric[:total]),
        'time_series': metric[:time_series]
      }
    end

    @single_page_data[:edition_metrics].each do |metric|
      @metrics[metric[:name]] = {
        'value': format_metric_value(metric[:name], metric[:total]),
        'time_series': nil
      }
    end

    @pdf_count = @metrics['pdf_count']['value']
    @words = @metrics['words']['value']

    @upviews = format_metric_value(:upviews, @metrics[:upviews])
    @pviews = format_metric_value(:pviews, @metrics[:pviews])
    @feedex = format_metric_value(:feedex, @metrics[:feedex])
    @searches = format_metric_value(:searches, @metrics[:searches])
    @satisfaction = format_metric_headline_figure(:satisfaction, @metrics[:satisfaction])
  end

  def parse_time_series
    @upviews_series = get_chart_presenter(@metrics['upviews'][:time_series], 'upviews')
    @pviews_series = get_chart_presenter(@metrics['pviews'][:time_series], 'pviews')
    @searches_series = get_chart_presenter(@metrics['searches'][:time_series], 'searches')
    @feedex_series = get_chart_presenter(@metrics['feedex'][:time_series], 'feedex')
    @satisfaction_series = get_chart_presenter(@metrics['satisfaction'][:time_series], 'satisfaction')
  end

  def add_glance_metric_presenters
    time_period = @date_range.time_period
    @upviews_glance_metric = GlanceMetricPresenter.new('upviews', @metrics['upviews'][:value], time_period)
    @satisfaction_glance_metric = GlanceMetricPresenter.new('satisfaction', @metrics['satisfaction'][:value], time_period)
    @searches_glance_metric = GlanceMetricPresenter.new('searches', @metrics['searches'][:value], time_period)
    @feedex_glance_metric = GlanceMetricPresenter.new('feedex', @metrics['feedex'][:value], time_period)
  end

  def get_chart_presenter(time_series, metric)
    ChartPresenter.new(json: time_series, metric: metric, from: date_range.from, to: date_range.to)
  end

  def format_date(date_str)
    Date.parse(date_str).strftime('%-d %B %Y')
  end
end
