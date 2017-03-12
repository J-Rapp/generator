module DomainBuilder
  class Domain
    attr_reader :html_file_paths

    def initialize(data)
      @data = data
      @html_file_paths = []
    end

    def build
      turn_keywords_into_filenames
    end

    private

    def turn_keywords_into_filenames
      @html_file_paths = @data[:keywords].map do |keyword|
        # downcase and remove leading/trailing whitespace
        keyword = keyword.downcase.strip

        # remove certain non-english characters
        keyword = keyword.gsub(/[å]/, 'aa')
        keyword = keyword.gsub(/[ø]/, 'oe')
        keyword = keyword.gsub(/[æ]/, 'ae')

        # remove special characters and spaces
        keyword = keyword.gsub(/[^0-9A-Za-z]/, '-')

        # cap filename at 250 characters
        keyword = keyword.slice(0..249)

        keyword + '.html'
      end
    end
  end
end
