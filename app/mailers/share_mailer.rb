class ShareMailer < ApplicationMailer

  def share_object(user, object, email)
    @user= user
    @object = object
    @email = email
    @object_class = @object.class.to_s.downcase
    @url = 'http://localhost:3000/v1/' + @object_class.pluralize + '/' + @object.id.to_s
    mail(to: @email, subject: '#{@user.account.display_name} shared a object_class on KEP with you ')
  end

end
