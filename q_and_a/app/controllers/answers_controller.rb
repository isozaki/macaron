class AnswersController < ApplicationController
  def new
    @question = Question.where(id: params[:question_id]).first
    @answer = Answer.new
  end

  def create
    @question = Question.find_by_id(params[:question_id])
    @answer = Answer.new(answer_params)
    @answer.created_user_name = logined_user.name
    @answer.updated_user_name = logined_user.name
    @answer.question_id = params[:question_id]

    ActiveRecord::Base.transaction do
      fail ActiveRecord::RecordInvalid.new(@answer) unless @answer.valid?
      @answer.save!
    end

    redirect_to(edit_status_question_url(@question))
  rescue ActiveRecord::RecordInvalid => e
    render :new
  end

  def edit
    @question = Question.find_by_id(params[:question_id])

    if params[:id].blank?
      redirect_to(question_url(@question), alert: '対象が指定されていません')
      return
    end

    @answer = Answer.where(id: params[:id]).first
    unless @answer
      redirect_to(question_url(@question), alert: '対象が見つかりません')
      return
    end
  end

  def update
    @question = Question.find_by_id(params[:question_id])

    if params[:id].blank?
      redirect_to(question_url(@question), alert: '対象が指定されていません')
      return
    end
    @answer = Answer.where(id: params[:id]).first
    unless @answer
      redirect_to(question_url(@question), alert: '対象が見つかりません')
      return
    end

    ActiveRecord::Base.transaction do
      @answer.updated_user_name = logined_user.name
      @answer.update!(answer_params)
    end

    redirect_to(edit_status_question_url(@question), notice: '回答を更新しました')
  rescue ActiveRecord::RecordInvalid => e
    render(:edit)
  end

  def destroy
    @question = Question.find_by_id(params[:question_id])
    @answer = Answer.find_by_id(params[:id])

    ActiveRecord::Base.transaction do
      @answer.destroy
      @answer.answer_attachment.destroy

      redirect_to(question_url(@question), notice: '回答を削除しました')
    end
  rescue => e
    redirect_to(question_url(@question), alert: '質問の削除に失敗しました')
  end

  def answer_params
    return {} if params[:answer].blank?

    params.require(:answer).permit(
      :question_id, :answer, :created_user_name, :updated_user_name
    )
  end
end
