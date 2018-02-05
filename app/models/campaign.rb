class Campaign < ApplicationRecord
  before_create :set_status
  before_create :set_member
  belongs_to :user
  enum status: [:pending, :finished]
  has_many :members, dependent: :destroy
  validates :title, :description, :user, :status, presence: true

  def set_status
    self.status = :pending
  end

  def set_member
    self.members << Member.create(name: self.user.name, email: self.user.email)
  end
end
