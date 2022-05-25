require 'forwardable'
require 'pathname'

Pathname.prepend Module.new {
  extend Forwardable

  def count_lines
    read.each_line.count
  end

  def replace(new_content = nil, &block)
    if (!new_content.nil? && !block.nil?) || (new_content.nil? && block.nil?)
      raise ArgumentError
    end

    unless new_content.nil? || new_content.is_a?(String)
      raise ArgumentError
    end

    if block
      new_content = block.call(read)

      return if new_content.nil?

      unless new_content.is_a?(String)
        raise 'block must return a String or nil'
      end
    end

    write(new_content)

    new_content
  end

  def replace_with_lines(&block)
    new_content = block.call(read.lines)

    return if new_content.nil?

    unless new_content.is_a?(Array) || new_content.is_a?(String)
      raise 'block must return an Array or a String or nil'
    end

    if new_content.is_a?(Array)
      write(new_content.join)
    else
      write(new_content)
    end

    new_content
  end

  delegate %i[each_line lines] => :read

  delegate %i[collect find grep grep_v map select] => :each_line
}

String.prepend Module.new {
  def to_p
    Pathname.new(self)
  end
}

def glob(...)
  Pathname.glob(...)
end

def grep(pattern, *globs, dotmatch: false, &block)
  flags = dotmatch ? File::FNM_DOTMATCH : 0
  file_paths = globs.map { |g| Pathname.glob(g, flags) }.flatten.select { |path| path.file? }
  file_paths.each_with_object({}) do |file_path, h|
    h[file_path] = file_path.read.each_line.grep(pattern, &block)
  end
end

def grep_v(pattern, *globs, dotmatch: false, &block)
  flags = dotmatch ? File::FNM_DOTMATCH : 0
  file_paths = globs.map { |g| Pathname.glob(g, flags) }.flatten.select { |path| path.file? }
  file_paths.each_with_object({}) do |file_path, h|
    h[file_path] = file_path.read.each_line.grep_v(pattern, &block)
  end
end

def pwd
  Pathname.pwd
end
