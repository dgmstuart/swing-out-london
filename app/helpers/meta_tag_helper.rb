# frozen_string_literal: true

module MetaTagHelper
  def opengraph_image_meta_tag
    tag.meta(
      property: "og:image",
      content: image_url(CITY.opengraph_image)
    )
  end
end
