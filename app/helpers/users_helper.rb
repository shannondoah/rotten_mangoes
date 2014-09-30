module UsersHelper

  def formatted_date(date)
    date.strftime("%b %e, %l:%M %p")
  end

end
