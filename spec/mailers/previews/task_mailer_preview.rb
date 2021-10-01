# Preview all emails at http://localhost:3000/rails/mailers/task_mailer
class TaskMailerPreview < ActionMailer::Preview
  def assigned_task
    TaskMailer.with(
      from: User.last.email,
      email: Task.first.user.email,
      name: Task.first.user.full_name,
      title: Task.first.title
    )
              .assigned_task
  end
end
