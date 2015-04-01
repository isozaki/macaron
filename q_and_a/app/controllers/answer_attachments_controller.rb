class AnswerAttachmentsController < ApplicationController
  def show
    question = Question.find_by_id(params[:question_id])
    answer = Answer.find_by_id(params[:answer_id])

    unless answer
      redirect_to(manage_questions_path, alert: '指定された回答は存在しません')
      return
    end

    answer_attachment = AnswerAttachment.find_by_id(params[:id])

    send_file(
      answer_attachment.file_path,
      filename: ERB::Util.url_encode(answer_attachment.filename)
    )
  rescue
    redirect_to(question_path(question), alert: 'ダウンロードに失敗しました')
  end

  def create
    @question = Question.find_by_id(params[:question_id])
    @answer = Answer.find_by_id(params[:answer_id])

    unless @answer
      redirect_to(questions_path(@question), alert: '指定された回答は存在しません')
      return
    end

    ActiveRecord::Base.transaction do
      if params[:attachment].present?
        AnswerAttachment.set_attachment(params[:attachment], @answer)

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
    @answer = Answer.find_by_id(params[:answer_id])

    unless @question
      redirect_to(question_path(@question), alert: '指定された回答は存在しません')
      return
    end

    ActiveRecord::Base.transaction do
      answer_attachment = AnswerAttachment.find_by_id(params[:id])
      answer_attachment.destroy

      redirect_to(question_path(@question), question: '添付ファイルを削除しました')
    end
  rescue
    redirect_to(question_path(@question), alert: '添付ファイルの削除に失敗しました')
  end
end
