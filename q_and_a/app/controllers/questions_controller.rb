class QuestionsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    # @question.updated_user_name = params[:created_user_name]
    
    ActiveRecord::Base.transaction do
      fail ActiveRecord::RecordInvalid.new(@question) unless @question.valid?
      @question.save!
    end

    redirect_to(question_url(@question), notice: '質問を登録しました')
  rescue ActiveRecord::RecordInvalid => e
    render :new
  end

  def edit
  end

  def question_params
    return {} if params[:question].blank?

    params.require(:question).permit(
      :title, :question, :charge, :priority, :status, :limit_datetime, :created_user_name,
      :updated_user_name
    )
  end
end
