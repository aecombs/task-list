class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    task_id = params[:id].to_i
    @task = Task.find_by(id: task_id)

    if @task.nil?
      redirect_to tasks_path
      return
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(
      name: params[:task][:name], 
      description: params[:task][:description], 
      completed_at: nil,
      completed: false
      )
    if @task.save
      redirect_to task_path(@task.id)
      return
    else
      render :new, :bad_request
      return
    end
  end

  def edit
    task_id = params[:id].to_i
    @task = Task.find_by(id: task_id)

    if @task.nil?
      head :not_found
      return
    end
  end

  def update
    task_id = params[:id].to_i
    @task = Task.find_by(id: task_id)
    if @task.nil?
      head :not_found
      return
    elsif @task.update(
          name: params[:task][:name], 
          description: params[:task][:description]
        )
          redirect_to task_path(task_id)
          return
    else
        render :edit
        return
    end
  end

  def destroy
    task_id = params[:id].to_i
    @task = Task.find_by(id: task_id)
    if @task.nil?
      head :not_found
      return
    end

    @task.destroy
    redirect_to tasks_path
    return
  end

  def mark_complete
    task_id = params[:id].to_i
    @task = Task.find_by(id: task_id)
    if @task.nil?
      head :not_found
      return
    elsif @task.update(
      completed_at: Time.now.strftime("%B %e, %Y at %I:%M %p"),
      completed: !@task.completed
    )
      redirect_to tasks_path
      return
    else
      render :index, :bad_request
    end
  end
end
