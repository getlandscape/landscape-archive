class Event < ApplicationRecord
  belongs_to :topic, required: false
end
