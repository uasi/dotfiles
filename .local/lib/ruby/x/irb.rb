require 'json'

module Kernel
  module_function

  def json
    return @_json if instance_variable_defined?(:@_json)

    @_json = STDIN.tty? ? nil : JSON.parse(STDIN.read)
  end
end

