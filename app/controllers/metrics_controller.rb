class MetricsController < ApplicationController
  include Concerns::DateRangeParser

  DEFAULT_METRICS = %w[pageviews unique_pageviews number_of_internal_searches].freeze

  def show
    service = MetricsService.new

    date_range = parse_date_range(params[:date_range])
    from = date_range[:from]
    to = date_range[:to]

    service_params = {
      base_path: params[:base_path],
      from: from,
      to: to,
      metrics: DEFAULT_METRICS
    }

    @summary = SingleContentItemPresenter
      .parse_metrics(service.fetch(service_params))
      .parse_time_series(service.fetch_time_series(service_params))
      .set_date_range(params[:date_range])
  end

  rescue_from GdsApi::HTTPNotFound do
    render file: Rails.root.join('public', '404.html'), status: :not_found
  end
end
