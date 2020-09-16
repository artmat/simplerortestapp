Rails.application.routes.draw do
  root to: 'rootpage#root'

  get  '/extract', to: 'translator_profiles#extract'
  get  '/save',    to: 'translator_profiles#verify'
  post '/save',    to: 'translator_profiles#save'
end
