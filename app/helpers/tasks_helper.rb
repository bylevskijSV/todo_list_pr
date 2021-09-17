module TasksHelper
  def status_color(status)
    {
      'new': 'danger',
      'in progress': 'warning',
      'done': 'success'
    }[status.to_sym]
  end
end
