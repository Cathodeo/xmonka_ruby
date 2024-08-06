class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true

  before_save :downcase_attributes

  private
  def downcase_attributes
    self.username = username.downcase
    self.email = email.downcase
  end
end
