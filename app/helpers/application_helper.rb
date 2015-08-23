module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def start_date(year, month)
    # :year, :month, :day
    Date.new(@year, @month, 1)
  end

  def end_date(start_date, lease_length)
    end_date = start_date + lease_length.months
  end
end
