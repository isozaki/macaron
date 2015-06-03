class QuestionPdf < Prawn::Document
  def initialize(question)
    super()

    @question = question

    font QAndA::Settings::FONT_PATH
    text "#{@question.title}"
  end
end
