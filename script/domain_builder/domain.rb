module DomainBuilder
  class Domain
    def initialize(data)
      @data = data
      @html_file_paths = nil
    end

    def build
      turn_keywords_into_paths
    end

    private

    def turn_keywords_into_paths
      @data[:keywords].each { |keyword| p keyword }
    end
  end
end
