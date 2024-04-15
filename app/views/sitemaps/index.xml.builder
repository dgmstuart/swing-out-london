# frozen_string_literal: true

xml.instruct! :xml, version: "1.0", encoding: "UTF-8"

xml.tag!(
  "urlset",
  "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9",
  "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
  "xsi:schemaLocation" => %w[
    http://www.sitemaps.org/schemas/sitemap/0.9
    http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd
  ].join(" ")
) do
  # Homepage
  render("url", builder: xml, link_url: root_url, change_frequency: "daily", priority: 1.0)

  # Info pages
  render("url", builder: xml, link_url: about_url, change_frequency: "monthly", priority: 0.8)
  render("url", builder: xml, link_url: listings_policy_url, change_frequency: "monthly", priority: 0.8)

  # Map
  render("url", builder: xml, link_url: map_socials_url, change_frequency: "daily", priority: 0.9)
  render("url", builder: xml, link_url: map_classes_url, change_frequency: "weekly", priority: 0.9)

  DAYNAMES.each do |day|
    render("url", builder: xml, link_url: map_classes_day_url(day:), change_frequency: "weekly", priority: 0.7)
  end

  render("url", builder: xml, link_url: privacy_url, change_frequency: "yearly", priority: 0.4)
end
