Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :developer unless Rails.env.production?
  #provider :facebook, Reader::Keys::FACEBOOK_API_KEY, Reader::Keys::FACEBOOK_SECRET
  #provider :google_oauth2, Reader::Keys::GOOGLE_API_KEY, Reader::Keys::GOOGLE_SECRET, {access_type: 'online', approval_prompt: ''}
end
