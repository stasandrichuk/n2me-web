namespace :mpx do
  desc 'Import books from xml file into MPX'
  task :import_books, [:file_name] => :environment do |t, args|
    file_path = File.expand_path(args[:file_name]) if args[:file_name]
    if file_path
      puts "Starting books import from file #{file_path}"
      if File.exist?(file_path)
        BookImport.new(file_path).process
      else
        puts "File #{file_path} not found."
      end
    else
      puts "Use this task with file as parameter: rake mpx:import_books[my-file.xml]"
    end
  end

  def put_hello
    puts "Hello"
  end
end
