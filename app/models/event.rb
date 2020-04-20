class Event < ApplicationRecord
  belongs_to :topic, required: false
  has_many   :tickets, dependent: :destroy

  validates :start_time, presence: true
end
