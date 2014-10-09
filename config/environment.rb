# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!
log_path = Rails.root.join('log')
log_path = log_path.to_s +  "/site_log.log"
`touch #{log_path}`

