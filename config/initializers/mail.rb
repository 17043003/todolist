ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address: 'smtp.gmail.com',
  domain: 'gmail.com',
  port: 587,
  user_name: 'ishizuka533725@gmail.com',
  password: "#{Rails.application.credentials.gmail}",
  authentication: 'plain',
  enable_starttls_auto: true
}