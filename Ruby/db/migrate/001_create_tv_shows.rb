class CreateTvShows < ActiveRecord::Migration
  def change
    create_table :tv_shows do |t|
      t.string :name
      t.string :path
      t.string :last_played
      t.string :pattern
      t.string :category
    end
  end
end