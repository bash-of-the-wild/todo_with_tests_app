require 'rails_helper'

RSpec.describe List, type: :model do
  describe '#complete_all_tasks!' do 
    it 'should mark all tasks from the list as complete' do 
      list = List.create(name: "My Favorite Things To Do")
      Task.create(complete: false, list_id: list.id)
      Task.create(complete: false, list_id: list.id)

      list.complete_all_tasks!

      list.tasks.each do |task|
        expect(task.complete).to eq(true)
      end
    end
  end

  describe '#snooze_all_tasks!' do 
    it 'should snooze each task from list' do 
      list = List.create(name: "Chores")
      times = [Time.now, 3.days.from_now, 40.seconds.ago]

      times.each do |time|
        Task.create(deadline: time, list_id: list.id)
      end

      list.snooze_all_tasks!
      tasks = list.tasks.order(:id)

      tasks.length.times do |index|
        expect(tasks[index].deadline).to eq(times[index] + 1.hour)
      end
    end
  end

  describe '#total_duration' do 
    it 'should return the sum of the duration of all the tasks' do 
      list = List.create(name: "Music to Listen to")
      Task.create(list_id: list.id, duration: 30)
      Task.create(list_id: list.id, duration: 60)
      Task.create(list_id: list.id, duration: 72)

      expect(list.total_duration).to eq(162)
    end
  end

  describe '#incomplete_tasks' do 
    it 'should return a collection of all incomplete tasks' do 
      list = List.create(name: "Coding Projects")
      task_1 = Task.create(list_id: list.id, complete: false)
      task_2 = Task.create(list_id: list.id, complete: false)
      Task.create(list_id: list.id, complete: true)
      Task.create(list_id: list.id, complete: true)

      expect(list.incomplete_tasks).to match_array([task_2, task_1])
      expect(list.incomplete_tasks.length).to eq(2)
    end
  end

  describe '#favorite_tasks' do 
    it 'should return a collection of all favorite tasks' do 
      list = List.create(name: "Finished Coding Projects")
      Task.create(list_id: list.id, favorite: false)
      task_2 = Task.create(list_id: list.id, favorite: true)
      Task.create(list_id: list.id, favorite: false)
      task_1 = Task.create(list_id: list.id, favorite: true)

      expect(list.favorite_tasks).to match_array([task_2, task_1])
      expect(list.favorite_tasks.length).to eq(2)
      
      list.favorite_tasks.each do |task|
        expect(task.favorite).to eq(true)
      end
    end
  end
end
