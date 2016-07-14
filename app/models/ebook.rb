class Ebook < ActiveRecord::Base
  paginates_per 16

  mount_uploader :file, FileUploader
  mount_uploader :picture, PictureUploader, mount_on: :image
end
