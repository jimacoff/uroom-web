class PagesController < ApplicationController
  # Controller to handle errors
  def index
    @date = Date.today.at_beginning_of_month.next_year
    @months = []
    (0..11).each do |m|
      @months << [@date.next_month(m).strftime("%b %Y"), @date.next_month(m)]
    end
  end
end
