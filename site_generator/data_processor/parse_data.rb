require 'csv'

p DATA_PATH
csv = CSV.read(DATA_PATH, col_sep: "\t", headers: true)
p csv

# inputs data files from wherever config files says they are
# returns a large nested data structure for the html_builder
