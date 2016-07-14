class Game < Medium
  before_save :set_game_checkbox
  self.table_name = 'media'

  default_scope -> { where(is_a_game: true) }

  private

  def set_game_checkbox
    self.is_a_game = true
  end
end
