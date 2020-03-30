class Ticket < ApplicationRecord
  belongs_to :user, required: false
  belongs_to :event, required: false
end
