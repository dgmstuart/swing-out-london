# frozen_string_literal: true

module ListingsRowsHelper
  def day_row(day, today, &)
    html_options =
      if DayNames.same_weekday?(day, today)
        { class: "day_row today", id: "classes_today" }
      else
        { class: "day_row" }
      end

    tag.li(**html_options, &)
  end

  def date_row(date, today, &)
    html_options =
      if date == today
        { class: "date_row today", id: "socials_today" }
      else
        { class: "date_row" }
      end

    tag.li(**html_options, &)
  end

  def day_header(day)
    url_options = { controller: :maps,
                    action: :classes,
                    day: }
    link_to day, url_options, title: "Click to view this day's weekly classes on a map"
  end

  def date_header(date, today)
    url_options = { controller: :maps,
                    action: :socials,
                    date: date.to_s(:db) }
    label_prefix = date_header_label_prefix(date, today)
    link_to url_options, title: "Click to view this date's events on a map" do
      if label_prefix
        concat label_prefix
        concat " "
      end
      concat date.to_s(:listing_date)
    end
  end

  def date_header_label_prefix(date, today)
    case date
    when today
      today_label
    when today + 1
      tomorrow_label
    end
  end

  # if there are no socials on this day, we need to add a class
  def socialsh2(socials_dates, &)
    if socials_dates.empty?
      tag.h2(id: "socials_today", &)
    else
      tag.h2(&)
    end
  end

  def today_label
    tag.strong("Today", class: "today_label")
  end

  def tomorrow_label
    tag.strong("Tomorrow", class: "tomorrow_label")
  end

  def classes_on_day(classes, day)
    classes.select { |e| e.day == day }.sort_by(&:venue_area)
  end
end
