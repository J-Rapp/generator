module DomainBuilder
  class SinglePage
    def initialize(keyword)
      @keyword = keyword
    end

    def build
      File.read(TEMPLATE_PATH)
    end
  end
end
