# Top level module acts as a wrapper/access point
# Much cleaner to call DomainBuilder.call(data) instead of
# DomainBuilder::Domain.new(domain_data).build on the script
module DomainBuilder
  def self.filenames(domain_data)
    domain = DomainBuilder::Domain.new(data: domain_data)
    domain.filenames
    domain
  end

  def self.html(domain_data, words)
    domain = DomainBuilder::Domain.new(data: domain_data, words: words)
    domain.html
    domain
  end
end
