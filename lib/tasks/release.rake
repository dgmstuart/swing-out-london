# frozen_string_literal: true

task ensure_schema: %w[environment] do
  # `current_version` fails the same way `db:version` does if there's something seriously wrong
  is_new_database = ActiveRecord::Base.connection_pool.migration_context.current_version.nil?
  Rake::Task["db:prepare"].invoke if is_new_database
end

task release: %w[environment ensure_schema db:migrate]
