desc "Pulls down a database dump from SOLDN1 production on heroku, migrates it to the SOLDN2 schema and dumps it to a file"
task :transform do
  Rake::Task['db:drop'].invoke
  Bundler.with_clean_env { system("heroku pg:pull HEROKU_POSTGRESQL_GRAY soldn1_dev --app soldneu") }
  Rake::Task['db:migrate'].invoke
  system("pg_dump soldn1_dev -a -t event_generators -t event_seeds -t events -t venues -t dance_classes > soldn1.dump")
end
