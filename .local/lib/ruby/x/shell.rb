require 'fileutils'
require 'pathname'

extend FileUtils

class Array
  def cd_each(**options, &block)
    each do |path|
      FileUtils.chdir(path, **options, &block)
    end
  end
end

def cd_each(paths, **options, &block)
  paths.cd_each(**options, &block)
end

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

# Overwrite methods from FileUtils.
extend Module.new {
  def pwd
    Pathname.pwd
  end
}
