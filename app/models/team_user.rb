# frozen_string_literal: true

class TeamUser < ApplicationRecord
  enum role: %i[owner member]
  enum status: %i[pendding accepted request]

  belongs_to :team, touch: true, counter_cache: true
  belongs_to :user

  validates :login, :team_id, :role, presence: true, on: :invite
  validates :user_id, :team_id, :role, presence: true, on: :request
  validates :user_id, uniqueness: { scope: :team_id, message: I18n.t("teams.user_existed") }

  attr_accessor :login, :actor_id

  before_validation do
    if login.present?
      u = User.find_by_login(login)
      self.errors.add(:login, :notfound) if u.blank?
      self.user_id = u&.id
    end
  end
  after_create_commit :notify_user_to_accept

  def status_name
    I18n.t("team_user_status.#{self.status}")
  end

  def role_name
    I18n.t("team_user_role.#{self.role}")
  end

  def notify_user_to_accept
    if self.pendding?
      Notification.create notify_type: "team_invite",
                          actor_id: self.actor_id,
                          user_id: self.user_id,
                          target: self,
                          second_target: team
    end
    if self.request?
      team.owner_ids.each do |owner_id|
        n = Notification.create notify_type: "team_request",
                            actor_id: self.actor_id,
                            user_id: owner_id,
                            target: self,
                            second_target: team
        p n
      end
    end
  end
end

