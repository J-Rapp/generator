module SinglePageBuilder
  class CreateSite
    # takes in the data/array from the processor
    # plugs individual tags into html template
    # outputs giant html string

    def initialize(site_data)
      @site_data = site_data
    end

    def build
      split_keywords # maybe should live in DataProcessor
      url_paths
    end

    private

    def split_keywords
      keywords = @site_data[:keywords]
      @site_data[:keywords] = keywords.split(',')
    end

    def url_paths
      @keywords.map
    end
  end
end
