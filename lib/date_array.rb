class DateArray
  #Class to manage interpreting and displaying string lists of dates and arrays of dates
  
  def initialize(date_array)
    @dates=date_array
  end
  
  # return a list of date strings
  def display(sep=nil)
    return UNKNOWN_DATE if @dates.nil? || @dates.empty?
    @dates.collect{ |d| d.to_s(:uk_date) }.join(sep) unless sep.nil?
  end
  
  def date_array  
    return [] if @dates.nil? || @dates.empty?
    @dates
  end
  
  def output(sep)
    if sep.nil?
      date_array
    else  
      display(sep)
    end
  end
  
  def inspect
    @dates.each { |d| puts d.to_s(:uk_date)}
  end

  def self.parse( date_string )
     #interpret a comma separated string as dates:
     if date_string.empty? || date_string == UNKNOWN_DATE #this is equivalent to empty
       string_array = [] 
     else
       string_array = date_string.split(',')
     end
     
     string_array.collect { |d| uk_date_from_string(d) }.sort
   end
  
  private
  
  #TODO: this is repeated in event.rb... need to find a common place for it...
  def self.uk_date_from_string(date_string)    
    #HACK - to get around stupid date parsing not recognising UK dates
    date_part_array = ParseDate.parsedate(date_string)
    return Date.new(date_part_array[0], date_part_array[2], date_part_array[1]) unless (date_part_array[0].nil? || date_part_array[2].nil? || date_part_array[1].nil?)
    logger.warn "WARNING: Bad date found: '#{date_string}' - ignored"
    return
  end
end