# CASE implementation for Arel
# Based on: https://github.com/take-five/acts_as_ordered_tree/blob/master/lib/acts_as_ordered_tree/transaction/dsl.rb
# Extended with support for CASE expr WHEN expr[, expr, ...] by Felix Buenemann
# https://gist.github.com/felixbuenemann/eb2e0f6c66469a98f748

module Arel
  module Nodes
    # Case node
    #
    # @example
    #   switch.when(table[:x].gt(1), table[:y]).else(table[:z])
    #   # CASE WHEN "table"."x" > 1 THEN "table"."y" ELSE "table"."z" END
    #   switch.when(table[:x].gt(1)).then(table[:y]).else(table[:z])
    class Case < ::Arel::Nodes::Node
      include Arel::Expression
      include Arel::Expressions
      include Arel::Predications
      include Arel::AliasPredication

      attr_reader :conditions, :default

      def initialize
        @conditions = []
        @default = nil
      end

      def when(condition, expression = nil)
        @conditions << When.new(condition, expression)
        self
      end

      def then(expression)
        @conditions.last.right = expression
        self
      end

      def else(expression)
        @default = Else.new(expression)
        self
      end
    end

    class When < Arel::Nodes::Binary
    end

    class Else < Arel::Nodes::Unary
    end
  end

  module Visitors
    class ToSql < ::Arel::Visitors::ToSql.superclass
      private
      def visit_Arel_Nodes_Case o, *a
        conditions = o.conditions.map { |x| visit x, *a }.join(' ')
        default = o.default && visit(o.default, *a)

        "CASE #{[conditions, default].compact.join(' ')} END"
      end

      def visit_Arel_Nodes_When o, *a
        "WHEN #{visit o.left, *a} THEN #{visit o.right, *a}"
      end

      def visit_Arel_Nodes_Else o, *a
        "ELSE #{visit o.expr, *a}"
      end

      def visit_Arel_Nodes_Coalesce(o, *a)
        "COALESCE(#{visit o.left}, #{visit o.right, *a})#{o.aliaz ? " AS #{visit o.aliaz, *a}" : ''}"
      end

      if Arel::VERSION >= '6.0.0'
        def visit_Arel_Nodes_Case o, collector
          collector << 'CASE '
          o.conditions.each do |x|
            visit x, collector
            collector << ' '
          end
          if o.default
            visit o.default, collector
            collector << ' '
          end
          collector << 'END'
        end

        def visit_Arel_Nodes_When o, collector
          collector << 'WHEN '
          visit o.left, collector
          collector << ' THEN '
          visit o.right, collector
        end

        def visit_Arel_Nodes_Else o, collector
          collector << 'ELSE'
          visit o.expr, collector
        end

        def visit_NilClass o, collector
          collector << 'NULL'
        end
      end
    end

    class DepthFirst < ::Arel::Visitors::DepthFirst.superclass
      def visit_Arel_Nodes_Case o, *a
        visit o.conditions, *a
        visit o.default, *a
      end

      def method_name
        visit o.alias, a
      end
      alias :visit_Arel_Nodes_When :binary
      alias :visit_Arel_Nodes_Else :unary
      alias :visit_Arel_Nodes_Coalesce :binary
    end
  end
end
