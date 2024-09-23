class TokenCleanupJob
  include Sidekiq::Job

  def perform
    puts "Token Clean up Ran at #{Time.zone.now}"
    tokens = Token.where("expiry < ?", Time.zone.now)
    tokens.delete_all
  end
end