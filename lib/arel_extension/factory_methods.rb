module Arel
  module FactoryMethods
    module_function
      def switch
        Arel::Nodes::Case.new
      end
  end
end
