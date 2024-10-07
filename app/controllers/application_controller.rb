class ApplicationController < ActionController::API
  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    header = request.headers['Authorization']
    begin
      @token = JsonWebToken.decode(header)
      @current_user = User.find(@token[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::ExpiredSignature
        return render json: { errors: ['Session Expired, Login again'] }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: ['Invalid token. Log in for a new one.'] }, status: :bad_request
    end
  end
end
