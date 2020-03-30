class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name
      t.integer :topic_id
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :can_register, default: true
      t.boolean :open_register, default: true
      t.string :location
      t.string :live_url
      t.integer :event_fee, default: 0
      t.string :pay_method

      t.timestamps
    end

    add_column :topics, :topic_type, :string, default: ''
  end
end
