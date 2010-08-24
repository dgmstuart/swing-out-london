module VenuesHelper
  
  def compass_dropdown(f)
    f.select :compass, COMPASS_POINTS, {:include_blank => true}
  end
end
