class SignupMailer < ApplicationMailer
  default from: "ishizuka533725@gmail.com"
  
  def creation_mail(user)
    @user = user
    mail(
      subject: 'ユーザ登録完了メール',
      to: "#{user.email}",
      from: "ishizuka533725@gmail.com"
    )
  end
end
