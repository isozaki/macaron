module QuestionsHelper
  def priority_name(priority)
    { 1 => '低', 2 => '中', 3 => '高' }[priority]
  end

  def status_name(status)
    { 
      1 => '回答待ち',
      2 => '回答済み',
      3 => '差し戻し',
      4 => '検討中',
      5 => '完了',
      6 => '却下'
    }[status]
  end

  def priority_select_from
    [["低", 1], ["中", 2], ["高", 3]]
  end

  def status_select_from
    [
      ["回答待ち", 1],
      ["回答済み", 2],
      ["差し戻し", 3],
      ["検討中", 4],
      ["完了", 5],
      ["却下", 6]
    ]
  end
end
