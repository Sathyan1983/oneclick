class Translation < ActiveRecord::Base

    validates_uniqueness_of :key, scope: :locale, message: "should occur once per language"
    
    validates :key, presence: true
    validates :locale, presence: true

    def self.available_locales
       I18n.available_locales
     end
end
