class QuestionPdf < Prawn::Document
  def initialize(question)
    super(page_size: 'A4', page_layput: :portrait)

    font QAndA::Settings::FONT_PATH

    @question = question

    header

    question_area

    answer_area
  end

  def header
    text '質問詳細', size: 20

    bounding_box([380, 770], width: 200, height: 50) do
      text "質問日：#{@question.created_at.strftime('%Y年%m月%d日')}"
      text "質問者：#{@question.created_user_name}"
    end

    stroke_color "000000"
    stroke_line [0, 740], [530, 740]
  end

  def question_area
    text "案件：#{@question.matter.title}", size: 16
    y_position = cursor - 20
    bounding_box([15, y_position], width: 500) do
      table question_table do
        cells.padding = 5
        self.column_widths = [100, 400]
      end
    end
  end

  def answer_area
    y_position = cursor - 20
    bounding_box([0, y_position], width: 530) do
      text '回答一覧', size: 16
      y_position = cursor - 10
      bounding_box([15, y_position], width: 500) do
        table answer_table do
          cells.padding = 5
          cells.borders = [:bottom]
          cells.border_width = 0.5

          row(0).border_width = 1.5

          self.header = true
          self.column_widths = [20, 260, 100, 110]
        end
      end
    end
  end

  def question_table
    question_data = [
      ['タイトル', @question.title],
      ['質問内容', @question.question],
      ['担当者', @question.charge],
      ['回答期限', @question.limit_datetime.strftime('%Y年%m月%d日')]
    ]
  end

  def answer_table
    answers_data = [['#', '回答内容', '回答者', '回答日']]

    @question.answers.map.with_index do |answer, i|
      answers_data << [i+1, answer.answer, answer.created_user_name, answer.created_at.strftime('%Y年%m月%d日')]
    end

    answers_data
  end
end
