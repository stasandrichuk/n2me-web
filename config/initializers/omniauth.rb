Rails.application.config.middleware.use OmniAuth::Builder do
  unless Rails.env.development?
    provider :facebook, '368210429969554', '5ae206097ac7be424b41b640396b8328', {:scope => 'email', :info_fields => 'name,email'}
    provider :twitter, 'sxy4RL1YxUljgMICKPAfSUXVU', 'fKhWrSOvT1EWA2r9HqvZOREYHLyOaQS9oF0Lyjozi7YEkrQ4nO'
  else
    provider :facebook, '556327564467007', '4a486673bfef45be54797a3110f8b6aa', {:scope => 'email', :info_fields => 'name,email'}
    provider :twitter, 'Dzv5LJjeBYvqh5wTzFowS7xxh', 'dhCZqNdmjFFCgouO9duzL3ZufqREiPMnG1I9tu7dLC7nvOR5RA'
  end
end