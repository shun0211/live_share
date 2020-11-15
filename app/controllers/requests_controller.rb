class RequestsController < ApplicationController
  def create
    @request = Request.new(request_params)
    redirect_back(fallback_location: root_path)
  end

  private

  def request_params
    params.permit(:ticket_id).merge(user_id: current_user.id)
  end

end
