class TestMailer < ApplicationMailer
  def hello_test(to)
    mail(
      to: to,
      subject: 'Test Brevo SMTP',
    )
  end
end
