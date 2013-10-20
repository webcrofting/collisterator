#create file at root: "secret_token", with the secret token inside

# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
#Collisterator::Application.config.secret_token = ''
begin
  token_file = Rails.root.to_s + "/secret_token"
  to_load = open(token_file).read
  Collisterator::Application.configure do
    config.secret_token = to_load
  end
rescue LoadError, Errno::ENOENT => e
  raise "Secret token couldn't be loaded! Error: #{e}"
end
