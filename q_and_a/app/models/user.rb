# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(64)       not null
#  name_kana  :string(64)       not null
#  login      :string(255)      not null
#  password   :string(16)       not null
#  deleted    :integer          default(0), not null
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  validates(:name, presence: true, length: { maximum: 64 })
  validates(:name_kana, presence: true, length: {maximum: 64})
  validates(:login, presence: true, uniqueness: true, length: { maximum: 255 }, format: { with: /\A[a-zA-Z0-9]+\z/i })
  validates(:password, presence: true, length: { maximum: 16, minimum: 4 }, confirmation: true,
            format: { with: /\A[a-zA-Z0-9]+\z/i })
end
