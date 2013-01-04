class ItemMailer < ActionMailer::Base
  default from: "team@1kpl.us"

  def item(email)
    @email = email
    mail(:from => email[:user].email, :to => email[:to], :subject => email[:subject],
         :template_path => 'item_mailer',
         :template_name => 'item')
  end

end
