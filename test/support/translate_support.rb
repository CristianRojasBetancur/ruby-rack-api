module Support
  module TranslateSupport
    def translate_field(model, field)
      I18n.t("models.attributes.#{model}.#{field}")
    end

    def translate_expected_message(error_url, complement = {})
      I18n.t(error_url, **complement)
    end
  end
end