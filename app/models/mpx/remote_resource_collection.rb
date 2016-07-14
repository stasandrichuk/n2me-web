class MPX::RemoteResourceCollection < Concurrent::Array
  attr_accessor :total_entries

  def self.build(resources, klass)
    collection = new
    resources['entries'].each do |entry|
      collection.push klass.new(entry)
    end
    collection.sort_by { |x| x.attributes[:title] }
  end
end
