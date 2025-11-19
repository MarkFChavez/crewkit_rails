class Team < ApplicationRecord
  has_many :team_members, dependent: :destroy

  validates :name, presence: true
  validates :company, presence: true

  scope :active, -> { where(active: true) }
  scope :archived, -> { where(active: false) }

  def member_count
    team_members.count
  end
end
