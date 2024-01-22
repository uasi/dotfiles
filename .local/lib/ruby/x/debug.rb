require 'time'

$x_debug_file = 'debug.log'
$x_debug_out = $stdout
$x_debug_time = :ruby # or :system

def debug_dump(*args)
  File.open($x_debug_file, 'a') do |f|
    args.each do |arg|
      f.puts("«#{debug_time}» #{arg.inspect}")
    end
  end
end
alias dd debug_dump

def debug_inspect(*args)
  if args.empty?
    $x_debug_out.puts("\e[33m«#{debug_time}»\e[0m")
  else
    $x_debug_out.puts(*args.map { |arg| "\e[33m«#{debug_time}»\e[0m #{arg.inspect}" })
  end
end
alias di debug_inspect

def debug_time
  case $x_debug_time
  when :ruby
    Time.now.iso8601
  when :system
    `date -Iseconds`.chomp
  else
    raise 'unrecognized value is set to $debug_time'
  end
end
