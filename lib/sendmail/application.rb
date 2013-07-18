class Sendmail::Application

  attr_reader :options

  def initialize(options)
    @options = symbolize_keys(options)
  end

  def run!
    mail = mailer(options)
    if options[:verbose]
      $stderr.puts "Sending the following email:"
      $stderr.puts mail
    end
    mail.deliver!
  end

  private
    def mailer(options)
      attachments = options.delete(:attachment) || []

      mail = Mail.new(slice_hash(options, :to, :from, :subject, :body))

      attachments.each do |attachment|
        mail.add_file(attachment)
      end

      mail.delivery_method :smtp, smtp_options
      mail
    end

    def smtp_options
      hsh = {}

      config_file = options[:extended_options][:config_file] || 'sendmail.yaml'

      if File.exist?(config_file)
        hsh.merge!(config_from_file(config_file)[:smtp] || {})
      end

      hsh.merge!(options[:extended_options][:smtp] || {})

      symbolize_keys(hsh)
    end

    def config_from_file(config_file)
      symbolize_keys(YAML.load_file(config_file)||{})
    end

    def slice_hash(hash, *keys)
      hash.select {|k, v| keys.include?(k)}
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
