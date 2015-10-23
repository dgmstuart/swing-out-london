class DatesStringParser
  def parse( date_string )
    String(date_string).split(',').map { |ds| safe_parse_date(ds) }.compact
  end

  private def safe_parse_date(ds)
    ds.to_date
  rescue
    #TODO: Log?
  end
end

