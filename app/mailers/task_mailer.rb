class TaskMailer < ApplicationMailer
  default from: 'notifications@todo.com'

  def assigned_task
    @email = params[:email]
    @from = params[:from]
    @title = params[:title]
    @name = params[:name]

    mail(
      to: email_address_with_name(@email, @name),
      subject: 'New task create!'
    )
  end
end
