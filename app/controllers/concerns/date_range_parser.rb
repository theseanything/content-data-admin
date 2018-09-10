require 'active_support/concern'

module Concerns::DateRangeParser
  extend ActiveSupport::Concern

  included do
    def parse_date_range(date_range)
      date_to_range(date_range)
    end
  end

private

  def date_to_range(date_range)
    case date_range
    when 'last-month'
      {
        from: Time.zone.today.last_month.beginning_of_month.to_s,
        to: Time.zone.today.last_month.end_of_month.to_s
      }
    when 'last-3-months'
      {
        from: (Time.zone.today - 3.months).to_s,
        to: Time.zone.today.to_s
      }
    when 'last-6-months'
      {
        from: (Time.zone.today - 6.months).to_s,
        to: Time.zone.today.to_s
      }
    when 'last-1-year'
      {
        from: (Time.zone.today - 1.year).to_s,
        to: Time.zone.today.to_s
      }
    when 'last-2-years'
      {
        from: (Time.zone.today - 2.years).to_s,
        to: Time.zone.today.to_s
      }
    else
      {
        from: (Time.zone.today - 30.days).to_s,
        to: Time.zone.today.to_s
      }
    end
  end
end
