class CreateActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :activities do |t|

      # モデル名/モデル名.idを保存するカラム
      t.references :target, null: false, polymorphic: true
      # 通知の種類を保存するカラム
      t.string :action
      # 通知を送ったユーザーを保存するカラム
      t.integer :visitor_id, null: false
      # 通知を送られたユーザーを保存するカラム
      t.integer :visited_id, null: false

      t.timestamps null: false
    end
  end
end
