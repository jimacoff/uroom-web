module ListingsHelper
  def start_date(month, year)
    # :year, :month, :day
    Date.new(year, month, 1)
  end

  def end_date(start_date, lease_length)
    lease_length > 0 ? start_date + lease_length.months : nil
  end
end
