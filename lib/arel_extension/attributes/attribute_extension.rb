module Arel
  module Attributes
    module AttributeExtension
      def date
        Arel::Nodes::NamedFunction.new('DATE', [self])
      end
    end
  end
end

Arel::Attributes::Attribute.send :include, Arel::Attributes::AttributeExtension
