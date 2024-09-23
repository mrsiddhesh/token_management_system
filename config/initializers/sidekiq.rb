Sidekiq::Cron::Job.load_from_hash!({
  'token_cleanup_job' => {
    'class' => 'TokenCleanupJob',
    'cron'  => '0 0 * * *'
  }
})
