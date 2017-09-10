class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@openbudgets.msbm.edu' #(ENV['MAILER_FROM_ADDRESS'] || 'no-reply@openbudgets.eu')
  layout 'mailer'

  # logger           = ActiveSupport::Logger.new(STDOUT)
  # logger.formatter = config.log_formatter
  # config.logger = ActiveSupport::TaggedLogging.new(logger)
  #
  # logger.info "Sending Email!!!!"
end
