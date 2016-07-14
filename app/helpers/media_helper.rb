module MediaHelper
  # TODO: this method should be removed/reworked
  # use conventions here (?, exists?)
  # the method doesn't belong here
  def in_favorites_list(media, user)
    return false unless media && user
    FavoriteMedium.find_by(media_number: media.number, user_id: user.id)
  end

  def video_player(media)
    # partial = 'shared/bitmovin_player'
    partial = 'shared/jw_player' # if media.file_url =~ /mobibase\.com/
    render partial: partial, locals: { media: media }
  end
end
