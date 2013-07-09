require 'optparse'

class Sendmail::CLI
  def run!
    # mailx [-BDdEFintv~] [-s subject] [-a attachment ] [-c cc-addr] [-b bcc-addr] [-r from-addr] [-h hops] [-A account] [-S variable[=value]] to-addr . . .
    options = {}
    OptionParser.new do |opts|
      opts.banner = "Usage: #{$PROGRAM_NAME} [options]"

      opts.on("-s subject") do |subject|
        options[:subject] = subject
      end

      opts.on("-a attachment") do |attachment|
        options[:attachment] ||= []
        options[:attachment] << attachment
      end

      opts.on("-c cc-addr") do |cc|
        options[:cc] = cc
      end

      opts.on("-b bcc-addr") do |bcc|
        options[:bcc] = bcc
      end

      opts.on("-r from-addr") do |from|
        options[:from] = from
      end

      opts.on_tail("-v", "--[no-]verbose", "Run verbosely") do |v|
        options[:verbose] = v
      end

      opts.on_tail("--help", "Print this help") do |v|
        puts opts
        exit
      end
    end.parse!

    options[:to] = []
    options[:to] = ARGV.dup
    ARGV.replace([])

    options[:body] = ARGF.read
    abort "Send options without primary recipient specified." if options[:to].empty?

    Sendmail::Application.new(options).run!
  end
end
