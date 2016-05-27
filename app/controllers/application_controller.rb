class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper 
  include ApplicationHelper
  
  before_filter :beforeFilter

  # Makes request available to be used in models
  def beforeFilter
    $request = request
  end

  
end
