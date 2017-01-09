class User::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters
  
  protected
  def configure_permitted_parameters
    # 讓devise套件知道在sign_up及account_update的時候, 需要再多家這兩個column, 一併新增及更新
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
end