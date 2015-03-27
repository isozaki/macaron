class QuestionAttachmentsController < ApplicationController
  def show
    question = Question.find_by_id(params[:question_id])

    unless question
      redirect_to(manage_questions_path, alert: '指定された質問は存在しません')
      return
    end

    question_attachment = QuestionAttachment.find_by_id(params[:id])

    send_file(
      question_attachment.file_path,
      filename: ERB::Util.url_encode(question_attachment.filename)
    )
  rescue
    redirect_to(question_path(question), alert: 'ダウンロードに失敗しました')
  end

  def create
    @question = Question.find_by_id(params[:question_id])

    unless @question
      redirect_to(questions_path(@question), alert: '指定された質問は存在しません')
      return
    end

    ActiveRecord::Base.transaction do
      if params[:attachment].present?
        QuestionAttachment.set_attachment(params[:attachment], @question)

        redirect_to(question_path(@question), question: 'ファイルを添付しました')
      else
        redirect_to(question_path(@question), alert: 'ファイルの添付に失敗しました')
      end
    end
  rescue => e
    redirect_to(question_path(@question), alert: "ファイルの添付に失敗しました")
  rescue
    redirect_to(question_path(@question), alert: 'アップロードに失敗しました')
  end

  def destroy
    @question = Question.find_by_id(params[:question_id])

    unless @question
      redirect_to(question_path(@question), alert: '指定された質問は存在しません')
      return
    end

    ActiveRecord::Base.transaction do
      question_attachment = QuestionAttachment.find_by_id(params[:id])
      question_attachment.destroy

      redirect_to(question_path(@question), question: '添付ファイルを削除しました')
    end
  rescue
    redirect_to(question_path(@question), alert: '添付ファイルの削除に失敗しました')
  end
end
