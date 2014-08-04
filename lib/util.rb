module SimpleCrm
  module Utils
    module Convert
      def to_in_hash
        self.collect do |arr|
          key, value = arr
          { key => value }
        end
      end
    end
  end
end

Array.send(:include, SimpleCrm::Utils::Convert)