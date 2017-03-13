require 'csv'

module DataProcessor
  class TSV
    def ingest
      # inputs data file from wherever config.rb declares it's located
      # col_sep: arg is because .tsv files are delimited by tabs
      # quote_char: arg is configured to avoid errors if quotes are in the data
      csv = CSV.read(DATA_PATH, headers: true, col_sep: "\t", quote_char: '|')
      csv = csv.map do |row|
        domain = row.to_a
        Hash[domain.map { |key, value| [key.to_sym, value] }]
      end
      split_delimited_cells(csv)
    end

    private

    def split_delimited_cells(csv)
      csv.map do |domain|
        domain[:keywords] = domain[:keywords].split(',')
        domain[:videos] = domain[:videos].split(',')
        domain
      end
    end
  end
end
