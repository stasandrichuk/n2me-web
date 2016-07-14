class Lineup < ActiveRecord::Base
  has_and_belongs_to_many :stations, join_table: 'lineups_stations'
end
