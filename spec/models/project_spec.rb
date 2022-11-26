require "rails_helper"

RSpec.describe Project do
  it_behaves_like "sizeable"

  describe "completion" do
    ## START: with_basic_factories
    describe "without a task" do
      let(:project) { build_stubbed(:project) }

      it "considers a project with no tasks to be done" do
        expect(project).to be_done
      end

      it "properly estimates a blank project" do
        expect(project.completed_velocity).to eq(0)
        expect(project.current_rate).to eq(0)
        expect(project.projected_days_remaining).to be_nan
        expect(project).not_to be_on_schedule
      end
    end

    describe "with a task" do
      let(:project) { build_stubbed(:project, tasks: [task]) }
      let(:task) { build_stubbed(:task) }

      it "knows that a project with an incomplete task is not done" do
        expect(project).not_to be_done
      end

      it "marks a project done if its tasks are done" do
        task.mark_completed
        expect(project).to be_done
      end
    end
    ## END: with_basic_factories
  end

  ## START: with_key_factories
  describe "estimates" do
    let(:project) { build_stubbed(:project, tasks: [newly_done, old_done, small_not_done, large_not_done]) }
    let(:newly_done) { build_stubbed(:task, size: 3, completed_at: 1.day.ago) }
    let(:old_done) { build_stubbed(:task, size: 2, completed_at: 6.months.ago) }
    let(:small_not_done) { build_stubbed(:task, size: 1) }
    let(:large_not_done) { build_stubbed(:task, size: 4) }

    it "can calculate total size" do
      expect(project).to be_of_size(10)
      expect(project).not_to be_of_size(5)
    end

    it "can calculate remaining size" do
      expect(project).to be_of_size(5).for_incomplete_tasks_only
    end
    ## END: with_key_factories

    it "knows its velocity" do
      expect(project.completed_velocity).to eq(3)
    end

    it "knows its rate" do
      expect(project.current_rate).to eq(1.0 / 7)
    end

    it "knows its projected days remaining" do
      expect(project.projected_days_remaining).to eq(35)
    end

    it "knows if it is not on schedule" do
      project.due_date = 1.week.from_now
      expect(project).not_to be_on_schedule
    end

    it "knows if it is on schedule" do
      project.due_date = 6.months.from_now
      expect(project).to be_on_schedule
    end
  end

  describe "estimates using factory bot features" do
    let(:project) { build_stubbed(:project, tasks: [newly_done, old_done, small_not_done, large_not_done]) }
    let(:newly_done) { build_stubbed(:task, :newly_complete) }
    let(:old_done) { build_stubbed(:task, :long_complete, :small) }
    let(:small_not_done) { build_stubbed(:task, :small) }
    let(:large_not_done) { build_stubbed(:task, :large) }

    it "can calculate total size" do
      expect(project).to be_of_size(10)
      expect(project).not_to be_of_size(5)
    end

    it "can calculate remaining size" do
      expect(project).to be_of_size(6).for_incomplete_tasks_only
    end
  end

  describe "completion old" do
    let(:project) { described_class.new }
    let(:task) { Task.new }

    it "considers a project with no tasks to be done" do
      # expect(project.done?).to be_truthy
      expect(project).to be_done
    end

    it "knows that a project with an incomplete task is not done" do
      project.tasks << task
      expect(project).not_to be_done
    end

    it "marks a project done if its tasks are done" do
      project.tasks << task
      task.mark_completed
      expect(project).to be_done
    end

    it "properly handles a blank project" do
      expect(project.completed_velocity).to eq(0)
      expect(project.current_rate).to eq(0)
      expect(project.projected_days_remaining).to be_nan
      expect(project).not_to be_on_schedule
    end
  end

  describe "estimates old" do
    let(:project) { described_class.new }
    let(:newly_done) { Task.new(size: 3, completed_at: 1.day.ago) }
    let(:old_done) { Task.new(size: 2, completed_at: 6.months.ago) }
    let(:small_not_done) { Task.new(size: 1) }
    let(:large_not_done) { Task.new(size: 4) }

    before do
      project.tasks = [newly_done, old_done, small_not_done, large_not_done]
    end

    it "can calculate total size" do
      expect(project.size).to eq(10)
      expect(project).to be_of_size(10)
      expect(project).not_to be_of_size(5)
    end

    it "can calculate remaining size" do
      expect(project.remaining_size).to eq(5)
      expect(project).to be_of_size(5).for_incomplete_tasks_only
    end

    it "knows its velocity" do
      expect(project.completed_velocity).to eq(3)
    end

    it "knows its rate" do
      expect(project.current_rate).to eq(1.0 / 7)
    end

    it "knows its projected days remaining" do
      expect(project.projected_days_remaining).to eq(35)
    end

    it "knows if it is not on schedule" do
      project.due_date = 1.week.from_now
      expect(project).not_to be_on_schedule
    end

    it "knows if it is on schedule" do
      project.due_date = 6.months.from_now
      expect(project).to be_on_schedule
    end
  end

  describe "without a task" do
    let(:project) { build_stubbed(:project) }

    it "considers a project with no tasks to be done" do
      expect(project).to be_done
    end

    it "properly estimates a blank project" do
      expect(project.completed_velocity).to eq(0)
      expect(project.current_rate).to eq(0)
      expect(project.projected_days_remaining).to be_nan
      expect(project).not_to be_on_schedule
    end
  end

  describe "with a task" do
    let(:project) { build_stubbed(:project, tasks: [task]) }
    let(:task) { build_stubbed(:task) }

    it "knows that a project with an incomplete task is not done" do
      expect(project).not_to be_done
    end

    it "marks a project done if its tasks are done" do
      task.mark_completed
      expect(project).to be_done
    end
  end
end
