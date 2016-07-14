require 'thread/pool'
class BookImport
  def initialize(file_path)
    @doc = File.open(file_path) { |f| Nokogiri::XML(f) }
    # pre-load classes (it fails in threads)
    Ebook
    HTTParty
  end

  def process
    books = Concurrent::Array.new(@doc.xpath('//Product'))
    books_count = books.count
    pool = Thread.pool(50)
    books_count.times do |n|
      pool.process do
        puts "process book #{n}"
        begin
          ActiveRecord::Base.connection_pool.with_connection do
            import_book(books[n])
          end
        rescue Exception => e
          puts "Exception with book #{n}!"
          puts e.class.to_s + ' ' + e.message
        end
      end
      pool.wait(:idle)
    end
    pool.shutdown

    puts "#{books.size} books imported"
  end

  def import_book(book)
    ebook = Ebook.new(parse_book_attributes(book))
    if Ebook.find_by(title: ebook.title)
      puts 'Book already exists'
      return
    end
    # pdf file
    pdf_file_url = pdf_file(book)
    file_response = HTTParty.head(pdf_file_url)
    unless file_response.code == 200
      puts 'Book has no pdf file'
      return
    end
    ebook.save
    ebook.remote_file_url = pdf_file_url

    cover_image_url = cover_file(book)
    cover_response = HTTParty.head(cover_image_url)
    ebook.remote_picture_url = cover_image_url if cover_response.code == 200
    ebook.save
  end

  def parse_book_attributes(book)
    {
      author: [css(book, 'NamesBeforeKey'), css(book, 'KeyNames')].join(' '),
      title: css(book, 'TitleText'),
      description: css(book, 'Text'),
      ean: css(book, 'EAN'),
      isbn: css(book, 'ISBN'),
      number_of_pages: css(book, 'NumberOfPages'),
      publication_date: format_date(css(book, 'PublicationDate')),
      publisher_name: css(book, 'PublisherName'),
      record_reference: css(book, 'RecordReference')
    }
  end

  def css(book, css_path)
    value = begin
              book.css(css_path).text
            rescue
              nil
            end
  end

  def format_date(date_str)
    Date.parse(date_str).strftime('%Y-%m-%d')
  rescue
    nil
  end

  def cover_file(book)
    name = File.basename book.css('CoverImageLink').text
    'http://www.n2me.tv/demo/images/ebooks/' << name if name.present?
  end

  def pdf_file(book)
    name = File.basename book.css('TextLink').text
    'http://www.n2me.tv/demo/images/ebooks/' << name if name.present?
  end
end
