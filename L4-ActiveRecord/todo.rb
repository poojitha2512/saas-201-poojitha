require "date"
require "active_record"

class Todo < ActiveRecord::Base
  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = Date.today == due_date ? nil : due_date
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.overdue
    all.where("due_date < ?", Date.today)
  end

  def self.due_today
    all.where("due_date = ?", Date.today)
  end

  def self.due_later
    all.where("due_date > ?", Date.today)
  end

  def self.show_list
    puts "My Todo-list\n\n"

    puts "Overdue\n"
    puts overdue.order(:id).map { |todo| todo.to_displayable_string }
    puts "\n\n"

    puts "Due Today"
    puts due_today.order(:id).map { |todo| todo.to_displayable_string }
    puts "\n\n"

    puts "Due Later"
    puts due_later.order(:id).map { |todo| todo.to_displayable_string }
    puts "\n\n"
  end

  def self.add_task(todo_hash)
    Todo.create(todo_text: todo_hash[:todo_text], due_date: Date.today + todo_hash[:due_in_days], completed: false)
  end

  def self.mark_as_complete!(todo_id)
    todo_record = Todo.find(todo_id)
    todo_record.update(completed: true)
    todo_record
  end
end
