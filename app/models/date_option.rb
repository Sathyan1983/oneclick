class DateOption < ActiveRecord::Base

  # return name value pairs suitable for passing to simple_form collection
  def self.form_collection include_all=true
    if include_all
      list = [[I18n.t(:all), -1]]
    else
      list = []
    end
    all.each do |o|
      list << [I18n.t(o.name), o.id]
    end
    list
  end
  
  def get_date_range
    if start_date == 'beginning of time'
      starting = DateTime.new(2013)
    else
      starting = Chronic.parse(start_date)
    end
    if end_date == 'end of time'
      ending = DateTime.new(2038)
    else
      ending = Chronic.parse(end_date)
    end

    if start_date.include? 'day'
      starting = starting.beginning_of_day
    elsif start_date.include? 'week'
      starting = starting.beginning_of_week
    elsif start_date.include? 'month'
      starting = starting.beginning_of_month
    end
    
    if end_date.include? 'day'
      ending = ending.end_of_day
    elsif end_date.include? 'week'
      ending = ending.end_of_week
    elsif end_date.include? 'month'
      ending = ending.end_of_month
    end
    
    return starting..ending
  end

end