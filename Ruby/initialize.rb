require "bundler"

Bundler.require
require "./tvshow"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "./tvmanager.sqlite"
)
