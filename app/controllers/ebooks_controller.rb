class EbooksController < ApplicationController
  layout 'new_layout'

  def index
    @ebooks = Ebook.page(params[:page])
  end

  def show
    @ebook = Ebook.find(params[:id])
  end
end
