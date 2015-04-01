module QuestionsHelper
  def priority_name(priority)
    { Question::PRIORITY[:low] => t('priority.low'),
      Question::PRIORITY[:mid] => t('priority.mid'),
      Question::PRIORITY[:high] => t('priority.high')
    }[priority]
  end

  def status_name(status)
    { 
      Question::STATUS[:unanswered] => t('status.unanswered'),
      Question::STATUS[:answered] => t('status.answered'),
      Question::STATUS[:remand] => t('status.remand'),
      Question::STATUS[:review] => t('status.review'),
      Question::STATUS[:completion] => t('status.completion'),
      Question::STATUS[:dismissal] => t('status.dismissal')
    }[status]
  end

  def priority_select_from
    [
      [t('priority.low'), Question::PRIORITY[:low]],
      [t('priority.mid'), Question::PRIORITY[:mid]],
      [t('priority.high'), Question::PRIORITY[:high]]
    ]
  end

  def status_select_from
    [
      [t('status.unanswered'), Question::STATUS[:unanswered]],
      [t('status.answered'), Question::STATUS[:answered]],
      [t('status.remand'), Question::STATUS[:remand]],
      [t('status.review'), Question::STATUS[:review]],
      [t('status.completion'), Question::STATUS[:completion]],
      [t('status.dismissal'), Question::STATUS[:dismissal]]
    ]
  end
end
