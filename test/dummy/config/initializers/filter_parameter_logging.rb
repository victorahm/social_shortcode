# Be sure to restart your server when you modify this file.

# Add additional parameters to be filtered from the log file.
Rails.application.config.filter_parameters += %i[passw email_pass secret access_key token]
