# frozen_string_literal: true

class Team < User
  has_many :team_users
  has_many :users, through: :team_users

  has_many :topics

  attr_accessor :owner_id
  after_create do
    self.team_users.create(user_id: owner_id, role: :owner, status: :accepted) if self.owner_id.present?
  end

  def owner_ids
    self.team_users.where(status: :accepted, role: :owner).ids
  end

  def member_ids # owner included
    self.team_users.where(status: :accepted).ids
  end

  def is_owner?(id)
    TeamUser.where(user_id: id, team_id: self.id, status: :accepted, role: :owner).any?
  end

  def is_member?(id) # owner included
    TeamUser.where(user_id: id, team_id: self.id, status: :accepted).any?
  end

  def user_ids
    @user_ids ||= self.users.pluck(:id)
  end

  def password_required?
    false
  end

  def owner?(user)
    self.team_users.accepted.exists?(role: :owner, user_id: user.id)
  end
end
