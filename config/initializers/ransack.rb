Ransack.configure do |config|
  config.search_key = :q

  config.add_predicate 'cont_cs',
                       arel_predicate: 'matches',
                       formatter: proc { |v| "%#{v}%" },
                       type: :string
end