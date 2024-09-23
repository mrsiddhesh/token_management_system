class Token < ApplicationRecord

	def assign_token_to_client
		update(expiry: Time.zone.now + $KEEP_ALIVE_INTERVAL, last_assigned_at: Time.zone.now)
	end
		
	def expired?
		Time.zone.now > expiry
	end

	def released?
		!expired? && last_assigned_at < $TOKEN_EXPIRY_TIME.seconds.ago
	end

	class << self
		# expiry should be greater than current time
		# last_assigned_at should be null or token should be assign 1 minute ago
		def fetch_to_assign
			Token.where("expiry > ? AND last_assigned_at IS NULL OR last_assigned_at < ?",Time.zone.now, $TOKEN_EXPIRY_TIME.seconds.ago).last
		end
	end
end