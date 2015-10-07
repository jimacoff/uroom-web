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

  def flash_present?
    exists = false
    flash.each do |message_type, message|
      exists = true if message.present?
    end
    return exists
  end

  def search_options
    [['San Francisco', 0], ['Silicon Valley', 1]]
  end

  def search_locations
    ["San Francisco, CA", "Silicon Valley, CA"]
  end

end
