require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post "tokens/generate", to: "token#create_tokens"
  post "tokens/assign", to: "token#assign"
  post "tokens/keep-alive", to: "token#keep_alive"
  post "tokens/unblock", to: "token#unblock"
  delete "tokens/delete", to: "token#delete"

  mount Sidekiq::Web => '/sidekiq'
end
