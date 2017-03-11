module DomainBuilder
  class Domain
    attr_reader :html_file_paths

    def initialize(data)
      @data = data
      @html_file_paths = []
    end

    def build
      turn_keywords_into_paths
    end

    private

    def turn_keywords_into_paths
      @html_file_paths = @data[:keywords].map do |keyword|
        # replace spaces with dashes
        keyword = keyword.downcase.strip.tr(' ', '-')

        # replace å = aa, ø = oe, æ = ae

        # remove special characters
        keyword = keyword.gsub(/[^0-9A-Za-z]/, '')

        # remove if more than 250 characters

        keyword
      end
    end
  end
end
