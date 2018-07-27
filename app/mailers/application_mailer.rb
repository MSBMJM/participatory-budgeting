class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@caribbeanopeninstitute.org' #(ENV['MAILER_FROM_ADDRESS'] || 'no-reply@openbudgets.eu')
  layout 'mailer'

  # logger           = ActiveSupport::Logger.new(STDOUT)
  # logger.formatter = config.log_formatter
  # config.logger = ActiveSupport::TaggedLogging.new(logger)
  #
  # logger.info "Trying tp Send Email!!!!"
  # Rails.logger.debug("Trying tp Send Email!!!!")
  # Rails.logger.debug(ENV['ANALYTICS_ID'])
  # Rails.logger.debug("Fearon")
  printf ENV['ANALYTICS_ID']
end
