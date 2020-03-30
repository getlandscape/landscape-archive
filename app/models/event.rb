class Event < ApplicationRecord
  belongs_to :topic, required: false
  has_many   :tickets, dependent: :destroy
end
