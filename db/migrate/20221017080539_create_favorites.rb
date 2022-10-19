class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|

      # 子タスクIDを保存するカラム
      t.integer :subtask_id, null: false
      # 会員IDを保存するカラム
      t.integer :member_id, null: false

      t.timestamps null: false
    end
  end
end
