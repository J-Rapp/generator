
module SinglePageBuilder
  def self.call(site_data)
    site = SinglePageBuilder::CreateSite.new(site_data)
    site.build
  end
end
