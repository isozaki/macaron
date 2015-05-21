# == Schema Information
#
# Table name: matters
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  deleted    :integer          default(0), not null
#  created_at :datetime
#  updated_at :datetime
#

class Matter < ActiveRecord::Base
  validates(:title, presence: true, length: { maximum: 255 })
  
  has_many(:matter_users)
  has_many(:questions)

  def self.search_matter(params)
    matters = Matter.order('id ASC')
    matters.where!('title LIKE ?', "%#{params[:title]}%") unless params[:title].blank?
    matters
  end
end
