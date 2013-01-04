class PlusMailer < ActionMailer::Base
  default from: "team@1kpl.us"

  def welcome(user)
    @user = user
    @url  = "http://1kpl.us/"
    mail(:to => user.email, :bcc => 'admin@1kpl.us', :subject => "Welcome to 1kpl.us!",
         :template_path => 'plus_mailer',
         :template_name => 'welcome')
  end

  def invite(friend_email, user)
    @user = user
    @url  = "http://1kpl.us/"
    mail(:to => friend_email, :bcc => 'admin@1kpl.us', :subject => "#{user.name} wants you to check out 1kpl.us!",
          :from => "1kplus Team <team@1kpl.us>",
         :template_path => 'plus_mailer',
         :template_name => 'invite')
  end

  def opml_imported(user)
    @user = user
    @url  = "http://1kpl.us/"
    mail(:to => user.email, :bcc => 'admin@1kpl.us', :subject => "#{user.name}, your feeds have finished importing to 1kpl.us!",
         :from => "1kplus Team <team@1kpl.us>",
         :template_path => 'plus_mailer',
         :template_name => 'opml_imported')
  end

end
