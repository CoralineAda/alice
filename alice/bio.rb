class Bio

  include Mongoid::Document

  field :text

  store_in collection: :alice_bios
  belongs_to :user

  def self.for(name)
    user = User.from(name)
    user && user.bio || Bio.new
  end

  def self.random
    all.sample
  end

  def formatted
    return Constants::WHO_DAT unless self.user
    return "It's #{self.user.proper_name}! " unless self.user.present?
    formatted_text = self.text.gsub(/^is /, ' ')
    formatted_text = "#{self.user.proper_name} is #{formatted_text}"
    formatted_text = formatted_text.gsub(/is (was|has|had|does|doesn.t) /, '\1 ')
    formatted_text = formatted_text.gsub(/[ ]+/, " ")
  end

end