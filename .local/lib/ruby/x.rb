require 'digest'
require 'pathname'
require 'securerandom'
require 'set'
require 'time'
require 'uri'

{
  'active_support/all' => 'activesupport',
  'awesome_print' => 'awesome_print',
}.each do |lib, gem_name|

  begin
    require lib
  rescue Gem::ConflictError => e
    warn "warning: #{e}"
  rescue LoadError
    system 'gem', 'i', gem_name
    warn "note: Restart to require #{lib}"
  end
end

autoload :EasyDB, 'x/easy_db'
autoload :XRails, 'x/rails'
