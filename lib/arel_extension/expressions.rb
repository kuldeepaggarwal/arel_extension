module Arel
  module Expressions
    def sum_without_alias
      Nodes::Sum.new([self])
    end
  end
end
