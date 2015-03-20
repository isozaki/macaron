class QuestionsController < ApplicationController
  def index
    @questions = Question.search_question(params)
  end

  def show
    if params[:id].blank?
      redirect_to(questions_url, alert: '対象が指定されていません')
      return
    end

    @question = Question.where(id: params[:id]).first
    unless @question
      redirect_to(questions_url, alert: '対象が見つかりません')
      return
    end

    @answers = Answer.where(question_id: params[:id]).order('created_at ASC')
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    
    ActiveRecord::Base.transaction do
      fail ActiveRecord::RecordInvalid.new(@question) unless @question.valid?
      @question.save!
    end

    redirect_to(question_url(@question), notice: '質問を登録しました')
  rescue ActiveRecord::RecordInvalid => e
    render :new
  end

  def edit
    if params[:id].blank?
      redirect_to(questions_url, alert: '対象が指定されていません')
      return
    end

    @question = Question.where(id: params[:id]).first
    unless @question
      redirect_to(questions_url, alert: '対象が見つかりません')
    end
  end

  def update
    if params[:id].blank?
      redirect_to(questions_url, alert: '対象が指定されていません')
      return
    end
    @question = Question.where(id: params[:id]).first
    unless @question
      redirect_to(questions_url, alert: '対象が見つかりません')
      return
    end

    ActiveRecord::Base.transaction do
      @question.update!(question_params)
    end

    redirect_to(question_url(@question), notice: '質問を更新しました')
  rescue ActiveRecord::RecordInvalid => e
     render(:edit)
  end

  def destroy
    @question = Question.find_by_id(params[:id])

    ActiveRecord::Base.transaction do
      @question.destroy
      @question.answers.each do |answer|
        answer.destoroy
      end
    end
    redirect_to(questions_url, notice: '質問を削除しました')
  rescue => e
     redirect_to(questions_url, alert: '質問の削除に失敗しました')
  end

  def edit_status
    if params[:id].blank?
      redirect_to(questions_url, alert: '対象が指定されていません')
      return
    end

    @question = Question.where(id: params[:id]).first
    unless @question
      redirect_to(questions_url, alert: '対象が見つかりません')
    end
  end

  def update_status
    if params[:id].blank?
      redirect_to(questions_url, alert: '対象が指定されていません')
      return
    end
    @question = Question.where(id: params[:id]).first
    unless @question
      redirect_to(questions_url, alert: '対象が見つかりません')
      return
    end

    ActiveRecord::Base.transaction do
      @question.update!(question_params)
    end

    redirect_to(question_url(@question), notice: 'ステータスを更新しました')
  rescue ActiveRecord::RecordInvalid => e
     render(:edit)
  end

  def question_params
    return {} if params[:question].blank?

    params.require(:question).permit(
      :title, :question, :charge, :priority, :status, :limit_datetime, :created_user_name,
      :updated_user_name
    )
  end
end
