class Sendmail::Application
  attr_reader :options

  def initialize(options)
    @options = options
  end

  def run!
    mail = mailer(options)
    mail.deliver!
  end


  private
    def mailer(options)
      attachments = options.delete(:attachment) || []
      mail = Mail.new(options)
      attachments.each do |attachment|
        mail.add_file(attachment)
      end

      smtp_options = symbolize_keys(YAML.load_file('mail.yaml'))
      mail.delivery_method :smtp, smtp_options
      mail
    end

    def symbolize_keys(hash)
      hash.inject({}) do |result, (key, value)|

        new_key = if key.instance_of?(String)
          key.to_sym
        else
          key
        end

        new_value = if value.respond_to?(:key)
          symbolize_keys(value)
        else
          value
        end

        result[new_key] = new_value
        result
      end
    end
end
