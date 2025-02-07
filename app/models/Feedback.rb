class Feedback
  attr_accessor :id, :title, :comment, :mark, :participant_username
  def initialize(id:, title:, comment:, mark:, participant_username:)
    @id = id
    @title = title
    @comment = comment
    @mark = mark
    @participant_username = participant_username
  end
end
