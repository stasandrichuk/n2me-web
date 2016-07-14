require 'thread/pool'
class GameImport
  def initialize(file_path)
    @games = JSON.parse File.read(file_path)
    # pre-load classes (it fails in threads)
    MPX::ResourceService
    MPX::FileManagement
    MPX::RemoteResource
    MPX::Media
  end

  def process
    not_saved = Concurrent::Array.new
    pool = Thread.pool(10)
    @games.each do |game|
      pool.process do
        puts "process game #{game['id']}"
        media = MPX::Media.new
        media.title = game['title']
        media.description = game['description']
        media.category = game['category']
        media.save
        if media.id.present?
          puts "game #{game['id']} saved as media ##{media.id}"
          MPX::FileManagement.link_file(media.id, game['content'])
          MPX::FileManagement.link_file(media.id, game['image']) if game['image'].present?
        else
          puts "*** Cant save game #{game['id']}"
          not_saved << game['id']
        end
      end
    end
    pool.shutdown
    puts 'done'
    puts "games not saved: #{not_saved}" unless not_saved.empty?
  end
end
