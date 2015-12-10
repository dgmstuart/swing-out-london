class XmasCancellations2015 < ActiveRecord::Migration
  def up
    CSV.parse(DATES_CSV, headers: true) do |row|
      event = Event.find(row["id"])
      puts "processing #{event.url}"
      event.url = row["New Url"]
      puts "old cancellations = #{event.cancellations}"
      event.cancellation_array = row["Cancelled dates"]
      puts "new cancellations = #{event.cancellations}"
      event.save
    end
  end

DATES_CSV = <<EOF
id,Old url,New Url,Cancelled dates
171,http://www.swingpatrol.co.uk/venues/angel/,http://www.swingpatrol.co.uk/class/angel,"15/12/2015, 22/12/2015, 29/12/2015"
772,http://www.swingpatrol.co.uk/venues/swing-patrol-archway/,http://www.swingpatrol.co.uk/class/archway,"16/12/2015, 23/12/2015, 30/12/2015"
730,http://www.swingpatrol.co.uk/venues/bethnal-green/,http://www.swingpatrol.co.uk/class/bethnal-green,"14/12/2015, 21/12/2015, 28/12/2015, 04/01/2016"
453,http://www.swingpatrol.co.uk/class/brixton-hill,http://www.swingpatrol.co.uk/class/brixton-hill,"24/12/2015, 31/12/2015"
98,http://www.swingpatrol.co.uk/venues/camberwell/,http://www.swingpatrol.co.uk/class/camberwell,"23/12/2015, 30/12/2015, 06/01/2016"
96,http://www.swingpatrol.co.uk/venues/camden/,http://www.swingpatrol.co.uk/class/camden,"14/12/2015, 21/12/2015, 28/12/2015"
817,http://www.swingpatrol.co.uk/class/clapham-junction,http://www.swingpatrol.co.uk/class/clapham-junction,"28/12/2015, 04/01/2016"
673,http://www.swingpatrol.co.uk/venues/crouch-end/,http://www.swingpatrol.co.uk/class/crouch-end,"16/12/2015, 23/12/2015, 30/12/2015"
646,http://www.swingpatrol.co.uk/jumpin-palace/,http://www.swingpatrol.co.uk/jumpin-palace/,"23/12/2015, 30/12/2015"
99,http://www.swingpatrol.co.uk/venues/dalston/,http://www.swingpatrol.co.uk/class/dalston,"23/12/2015, 30/12/2015"
292,http://www.swingpatrol.co.uk/venues/finsbury-park/,http://www.swingpatrol.co.uk/class/finsbury-park,"15/12/2015, 22/12/2015, 29/12/2015, 05/01/2016"
929,http://www.swingpatrol.co.uk/class/forest-gate,http://www.swingpatrol.co.uk/class/forest-gate,"21/12/2015, 28/12/2015"
173,http://www.swingpatrol.co.uk/class/harringay,http://www.swingpatrol.co.uk/class/harringay,"22/12/2015, 29/12/2015"
930,http://www.swingpatrol.co.uk/class/holloway,http://www.swingpatrol.co.uk/class/holloway,28/12/2015
946,http://www.swingpatrol.co.uk/class/homerton,http://www.swingpatrol.co.uk/class/homerton,"17/12/2015, 24/12/2015, 31/12/2015"
189,http://www.swingpatrol.co.uk/class/kilburn,http://www.swingpatrol.co.uk/class/kilburn,"02/12/2015, 09/12/2015, 16/12/2015, 23/12/2015, 30/12/2015"
754,http://www.swingpatrol.co.uk/class/kings-cross,http://www.swingpatrol.co.uk/class/kings-cross,"23/12/2015, 30/12/2015"
826,http://www.swingpatrol.co.uk/class/lewisham,http://www.swingpatrol.co.uk/class/lewisham,"22/12/2015, 29/12/2015, 05/01/2016"
904,http://www.swingpatrol.co.uk/jazz-pie-london-bridge/,http://www.swingpatrol.co.uk/jazz-pie-london-bridge/,"02/12/2015, 09/12/2015, 16/12/2015, 23/12/2015, 30/12/2015"
721,http://www.swingpatrol.co.uk/class/notting-hill,http://www.swingpatrol.co.uk/class/notting-hill,"17/12/2015, 24/12/2015, 31/12/2015"
21,http://www.swingpatrol.co.uk/venues/old-street/,http://www.swingpatrol.co.uk/class/old-street,"21/12/2015, 28/12/2015, 04/01/2016"
643,http://www.swingpatrol.co.uk/class/shoreditch,http://www.swingpatrol.co.uk/class/shoreditch,"20/12/2015, 27/12/2015, 03/01/2016"
471,http://www.swingpatrol.co.uk/class/sin-city-blues,http://www.swingpatrol.co.uk/class/sin-city-blues,"22/12/2015, 29/12/2015, 05/01/2016"
662,http://www.swingpatrol.co.uk/venues/soho/,http://www.swingpatrol.co.uk/class/soho,"24/12/2015, 31/12/2015, 07/01/2016"
853,http://www.swingpatrol.co.uk/class/solo-with-cat,http://www.swingpatrol.co.uk/class/solo-with-cat,"16/12/2015, 23/12/2015, 30/12/2015"
788,http://www.swingpatrol.co.uk/class/spitalfields,http://www.swingpatrol.co.uk/class/spitalfields,"01/12/2015, 08/12/2015, 15/12/2015, 22/12/2015, 29/12/2015"
645,http://www.swingpatrol.co.uk/class/stompin-the-blues,http://www.swingpatrol.co.uk/class/stompin-the-blues,"23/12/2015, 30/12/2015, 06/01/2016"
821,http://www.swingpatrol.co.uk/class/vauxhall,http://www.swingpatrol.co.uk/class/vauxhall,"15/12/2015, 22/12/2015, 29/12/2015"
97,http://www.swingpatrol.co.uk/class/victoria-park,http://www.swingpatrol.co.uk/class/victoria-park,"22/12/2015, 29/12/2015"
142,http://www.swingpatrol.co.uk/class/waterloo/,http://www.swingpatrol.co.uk/class/waterloo,"17/12/2015, 24/12/2015, 31/12/2015"
748,http://www.swingpatrol.co.uk/class/west-dulwich,http://www.swingpatrol.co.uk/class/west-dulwich,"22/12/2015, 29/12/2015"
663,http://www.swingpatrol.co.uk/venues/wimbledon/,http://www.swingpatrol.co.uk/class/wimbledon,"21/12/2015, 28/12/2015"
854,http://www.swingpatrol.co.uk/swing-den-bishopsgate-institute/,http://www.swingpatrol.co.uk/swing-den-bishopsgate-institute/,"15/01/2016, 26/02/2016"
EOF
end
