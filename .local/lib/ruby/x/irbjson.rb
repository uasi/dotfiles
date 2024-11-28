require 'json'
require 'pathname'

module IRBJSON
  module_function
    
  def init
    Object.include IRBJSON::ObjectMixin

    IRB.conf[:IRB_NAME] = 'irbjson'

    puts 'usage: json                         - loads JSON from STDIN or ARGV[0]'
    puts 'usage: save(obj, path = "out.json") - saves JSON to path'
  end
    
  module ObjectMixin
    def json
      return @_json if instance_variable_defined?(:@_json)

      @_json =
        IO.open(3) do |fd3|
          if fd3.tty?
            if ARGV.empty?
              nil
            else
              JSON.load(open(ARGV.first))
            end
          else
            JSON.load(fd3)
          end
        end
    end

    def save(obj, path = 'out.json', generate_opts = nil)
      Pathname(path).open('w') do |f|
        f.puts JSON.pretty_generate(obj, generate_opts)
      end
    end
  end
end

IRBJSON.init

