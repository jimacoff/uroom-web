module ListingsHelper
  def start_date(month, year)
    # :year, :month, :day
    Date.new(year, month, 1)
  end

  def end_date(start_date, lease_length)
    end_date = start_date + lease_length.months
  end
end
