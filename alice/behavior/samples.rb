module Behavior

  module Samples

    def self.included(klass)
      klass.send(:field, :last_sampled_at, type: DateTime)
      klass.extend ClassMethods
    end

    module ClassMethods
      def sample
        return unless samples = asc(:last_sampled_at)
        return samples.first if samples.count == 1
        sample = samples[0..-2].sample
        sample.update_attribute(:last_sampled_at, DateTime.now)
        sample
      end
    end

  end

end
