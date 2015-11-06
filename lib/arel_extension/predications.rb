module Arel
  module Predications
    def coalesce(value)
      Arel::Nodes::Coalesce.new([self], value, Nodes::SqlLiteral.new('coalesce_id'))
    end
  end
end
