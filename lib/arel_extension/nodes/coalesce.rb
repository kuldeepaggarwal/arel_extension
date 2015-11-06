module Arel
  module Nodes
    class Coalesce < Arel::Nodes::Binary
      attr_reader :aliaz
      def initialize(left, right, aliaz = nil)
        super(left, right)
        as(aliaz)
      end

      def as(aliaz)
        @aliaz = aliaz && SqlLiteral.new(aliaz)
        self
      end

      def hash
        super ^ @aliaz.hash
      end

      def eql? other
        super && @aliaz == other.aliaz
      end
    end
  end

  module Visitors
    class ToSql < ::Arel::Visitors::ToSql.superclass
      private
      def visit_Arel_Nodes_Coalesce(o, *a)
        "COALESCE(#{visit o.left}, #{visit o.right, *a})#{o.aliaz ? " AS #{visit o.aliaz, *a}" : ''}"
      end
    end

    class DepthFirst < ::Arel::Visitors::DepthFirst.superclass
      alias :visit_Arel_Nodes_Coalesce :binary
    end
  end
end
