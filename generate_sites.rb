# this will first create a new directory
# it then fires up the data processor
# it will iterate over each site to be made
  # generates a new subdirectory for the site
  # builds the giant html string
  # creates an index.html from each built string
  # includes asset files from the template
# printing out progress along the way

# From 'require_all' gem
def require_all(dir)
  files = Dir.glob File.join(dir, '**', '*.rb')
  files.map! { |fyle| File.expand_path fyle }
  files.sort!
  loop do
    failed = []
    first_error = nil
    files.each do |fyle|
      begin
        Kernel.send(:require, fyle)
      rescue NameError => ex
        failed << fyle
        first_error ||= ex
      rescue ArgumentError => ex
        # Swallow occasional Active Record exceptions
        raise unless ex.message['is not missing constant']
        STDERR.puts 'Warning: require_all swallowed an error'
        STDERR.puts ex.backtrace[0..9]
      end
    end
    break if failed.empty?
    raise first_error if failed.size == files.size
    files = failed
  end
  true
end

require_all('site_generator')

call('files are required')
