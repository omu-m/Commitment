class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|

      # 親タスク(グループ)作成者をowner_idに
      t.integer :owner_id, null: false
      # 親タスクのタイトルを保存するカラム
      t.string :task_title, null: false
      # 親タスクの内容を保存するカラム
      t.text :task_content, null: false
      # 承認ステータスを保存するカラム
      t.integer :approval_status, null: false, default: 0

      t.timestamps null: false
    end
  end
end
