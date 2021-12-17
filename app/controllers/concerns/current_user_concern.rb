module CurrentUserConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_current_user
  end

  def set_current_user
    @current_user = session[:user_id] ? User.find(session[:user_id]) : nil
  end

  private

  attr_reader :current_user
end
