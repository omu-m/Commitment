class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|

      # 親タスク(グループ)作成者をowner_idに
      t.integer :owner_id, null: false
      # 親タスクのタイトルを保存するカラム
      t.string :task_title, null: false
      # 親タスクの内容を保存するカラム
      t.text :task_content, null: false
      # # 達成率を保存するカラム
      # t.float :achievement_rate, null: false
      
      # ゲストユーザーが遷移できないように
      # ユーザーネームを保存するカラム
      t.string :user_name, null: false

      t.timestamps null: false
    end
  end
end
