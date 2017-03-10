module DataProcessor
  def self.call
    DataProcessor::TSV.new.ingest
  end
end
