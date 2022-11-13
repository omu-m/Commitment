class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|

      # 通知を送ったユーザーを保存するカラム
      t.integer :visitor_id, null: false
      # 通知を送られたユーザーを保存するカラム
      t.integer :visited_id, null: false
      # アソシエーション(通知の種類)を保存するカラム
      t.integer :association_id
      # 通知の種類を保存するカラム
      t.string :action, null: false, default: ''
      # 通知を送られたユーザーが通知を確認したかどうかを保存するカラム
      t.boolean :check, null: false, default: false

      t.timestamps null: false
    end

    add_index :notifications, :visitor_id
    add_index :notifications, :visited_id
    add_index :notifications, :association_id

  end
end
