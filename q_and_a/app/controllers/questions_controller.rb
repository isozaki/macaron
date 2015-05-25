class QuestionsController < ApplicationController
  def index
    @questions = Question.where(matter_id: params[:matter_id]).search_question(params)
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
    @question.matter_id = params[:matter_id]
    @question.created_user_name = logined_user.name
    @question.updated_user_name = logined_user.name
    
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
      return
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
      @question.updated_user_name = logined_user.name
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
      if @question.question_attachment.present?
        @question.question_attachment.destroy
      end
      if @question.answers.first.present?
        @question.answers.each do |answer|
          answer.destroy
          if answer.answer_attachment.present?
            answer.answer_attachment.destroy
          end
        end
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
      @question.updated_user_name = logined_user.name
      @question.update!(question_params)
    end

    redirect_to(question_url(@question), notice: 'ステータスを更新しました')
  rescue ActiveRecord::RecordInvalid => e
    render(:edit)
  end

  def q_and_a_download
    ActiveRecord::Base.transaction do
      path = File.join(Dir.tmpdir, Time.now.to_i.to_s + '_q_and_a.csv')
      Answer.generate_q_and_a_file(path)

      send_file(path, filename: "q_and_a_#{Time.now.strftime('%Y%m%d')}.csv")
    end
  rescue => e
    redirect_to(questions_url, alert: 'ダウンロードに失敗しました')
  end

  def question_params
    return {} if params[:question].blank?

    params.require(:question).permit(
      :matter_id, :title, :question, :charge, :priority, :status, :limit_datetime, :created_user_name,
      :updated_user_name
    )
  end
end
