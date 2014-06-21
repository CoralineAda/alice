module Behavior

  module Samples

    def self.included(klass)
      klass.send(:field, :last_sampled_at, type: DateTime)
      klass.extend ClassMethods
    end

    module ClassMethods
      def sample
        return unless sample = all.asc(:last_sampled_at)[0..-2].sample
        sample.update_attribute(:last_sampled_at, DateTime.now)
        sample
      end
    end

  end

end
