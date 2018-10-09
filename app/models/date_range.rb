class DateRange
  attr_reader :time_period
  def initialize(time_period)
    @time_period = time_period
  end

  def to
    date_to_range[:to]
  end

  def from
    date_to_range[:from]
  end

  def prev_from
    date_to_range[:prev_from]
  end

  def prev_to
    date_to_range[:prev_to]
  end


private

  def date_to_range
    case time_period
    when 'last-month'
      {
        prev_from: (Time.zone.today - 2.months).beginning_of_month.to_s,
        prev_to: (Time.zone.today - 2.months).end_of_month.to_s,
        from: Time.zone.today.last_month.beginning_of_month.to_s,
        to: Time.zone.today.last_month.end_of_month.to_s
      }
    when 'last-3-months'
      {
        prev_from: (Time.zone.today - 6.months).to_s,
        prev_to: (Time.zone.today - 3.months).to_s,
        from: (Time.zone.today - 3.months).to_s,
        to: Time.zone.today.to_s
      }
    when 'last-6-months'
      {
        prev_from: (Time.zone.today - 12.months).to_s,
        prev_to: (Time.zone.today - 6.months).to_s,
        from: (Time.zone.today - 6.months).to_s,
        to: Time.zone.today.to_s
      }
    when 'last-year'
      {
        prev_from: (Time.zone.today - 2.years).to_s,
        prev_to: (Time.zone.today - 1.year).to_s,
        from: (Time.zone.today - 1.year).to_s,
        to: Time.zone.today.to_s
      }
    when 'last-2-years'
      {
        prev_from: (Time.zone.today - 4.years).to_s,
        prev_to: (Time.zone.today - 2.years).to_s,
        from: (Time.zone.today - 2.years).to_s,
        to: Time.zone.today.to_s
      }
    else
      {
        prev_from: (Time.zone.today - 60.days).to_s,
        prev_to: (Time.zone.today - 30.days).to_s,
        from: (Time.zone.today - 30.days).to_s,
        to: Time.zone.today.to_s
      }
    end
  end
end
