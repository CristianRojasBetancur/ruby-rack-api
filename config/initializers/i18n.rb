require 'i18n'

I18n.load_path += Dir[File.join(__dir__, '../locales', '*.yml')]
I18n.available_locales = [:es]
I18n.default_locale = :es
