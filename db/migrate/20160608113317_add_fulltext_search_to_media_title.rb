class AddFulltextSearchToMediaTitle < ActiveRecord::Migration
  def up
    sql = 'CREATE INDEX "index_media_on_title" ON "media" USING gin(to_tsvector(\'english\', "title"))'
    ActiveRecord::Base.connection.execute(sql)
  end

  def down
    sql = 'DROP INDEX "index_media_on_title"'
    ActiveRecord::Base.connection.execute(sql)
  end
end
