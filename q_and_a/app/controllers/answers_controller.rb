class AnswersController < ApplicationController
  def new
    @question = Question.where(id: params[:question_id]).first
    @answer = Answer.new
  end

  def create
    @question = Question.find_by_id(params[:question_id])
    @answer = Answer.new(answer_params)
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
  end

  def answer_params
    return {} if params[:answer].blank?

    params.require(:answer).permit(
      :question_id, :answer, :created_user_name, :updated_user_name
    )
  end
end
