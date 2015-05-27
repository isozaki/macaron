# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(64)       not null
#  name_kana       :string(64)       not null
#  login           :string(255)      not null
#  password_digest :string(255)      not null
#  deleted         :integer          default(0), not null
#  created_at      :datetime
#  updated_at      :datetime
#  admin           :integer          default(0), not null
#

class User < ActiveRecord::Base
  ADMIN = {
    none: false,
    admin: true
  }

  has_secure_password

  validates(:name, presence: true, length: { maximum: 64 })
  validates(:name_kana, presence: true, length: {maximum: 64})
  validates(:login, presence: true, on: :create, uniqueness: true, length: { maximum: 255 }, format: { with: /\A[a-zA-Z0-9]+\z/i })
  validates(:password, presence: true, on: :create, length: { maximum: 16, minimum: 4 }, confirmation: true,
            format: { with: /\A[a-zA-Z0-9]+\z/i })
  validates(:admin, inclusion: { in: [true, false] })

  has_many(:matter_users)
  has_many(:matters, through: :matter_users)

  def self.search_user(params)
    params[:page] ||= 1
    params[:per] ||= 5
    users = User.order('id ASC').page(params[:page]).per(params[:per])

    users.where!('name LIKE ?', "%#{params[:name]}%") unless params[:name].blank?
    users.where!('name_kana LIKE ?', "%#{params[:name_kana]}%") unless params[:name_kana].blank?

    users
  end
end
