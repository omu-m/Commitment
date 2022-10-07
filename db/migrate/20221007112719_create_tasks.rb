class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|

      # 会員IDを保存するカラム
      t.integer :member_id, null: false
      # 親タスクのタイトルを保存するカラム
      t.string :task_title, null: false
      # 親タスクの内容を保存するカラム
      t.text :task, null: false
      # 達成率を保存するカラム
      t.float :achievement_rate, null: false

      t.timestamps null: false
    end
  end
end
