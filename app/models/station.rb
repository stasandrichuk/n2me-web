class Station < ActiveRecord::Base
  has_and_belongs_to_many :lineups, join_table: 'lineups_stations'
  has_and_belongs_to_many :users, join_table: 'users_stations'
end
