class TokenController < ApplicationController
	skip_before_action :verify_authenticity_token

	def create_tokens
		tokens = []
		$MAX_TOKENS.times do
			tokens << {token_id: SecureRandom.hex(8), expiry: Time.zone.now + $KEEP_ALIVE_INTERVAL.seconds}
		end
		Token.create(tokens)
		render json: { message: "#{$MAX_TOKENS} tokens created successfully" }, status: :created
	end

	def assign
		token = Token.fetch_to_assign
		if token
      token.assign_token_to_client
      render json: { token: token.token_id }, status: :ok
    else
      render json: { error: 'No tokens available' }, status: 404
    end
	end

	def unblock
    token_id = params[:token]
    token = Token.find_by(token_id: token_id)
    if token.blank? || token.expired?
    	return render json: { error: "Token Not Found with token id #{token_id}" }, status: 404
    end
    token.update(expiry: Time.zone.now + $KEEP_ALIVE_INTERVAL.seconds, last_assigned_at: nil)
    render json: { message: 'Token unblocked' }, status: :ok
  end

  def delete
  	token_id = params[:token]
  	token = Token.find_by(token_id: token_id)
  	if token.blank?
    	return render json: { error: "Token Not Found with token id #{token_id}" }, status: 404
    end
    token.delete
    render json: { message: 'Token Deleted.!' }, status: :ok
  end

  def keep_alive
  	token_id = params[:token]
  	token = Token.find_by(token_id: token_id)
  	if token.blank?
  		render json: { error: 'Token not found' }, status: 404
  	elsif token.expired?
  		token.delete
  		render json: { error: 'Not Found, token is expired' }, status: 404
  	elsif token.released?
  		render json: { error: 'Not Found, token is released' }, status: 404
  	else
  		token.assign_token_to_client
  		render json: { message: 'Token is Allocate to you again.!' }, status: :ok
  	end
  end
end