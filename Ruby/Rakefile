require "./initialize"
require "csv"
namespace :db do
  desc "Migrate the database"
  task(:migrate) do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end

  desc "Seed DB from the CSV"
  task :import do
    TvShow.destroy_all

    CSV.open("../tvmandb", row_sep: :auto) do |csv|
      headers = csv.readline
      headers[3] = "last_played" # name different in ruby than perl

      csv.read.each do |row|
        TvShow.create! Hash[headers.zip row].keep_if{|k,v| TvShow.attribute_names.include? k} # extras not ignored
      end
    end
  end
end
