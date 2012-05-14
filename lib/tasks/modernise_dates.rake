desc "Move all the dates from serialised strings into the dates table"
task :modernise_dates => :environment do
  Event.all.each{ |e| e.modernise }
end
