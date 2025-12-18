module Support
  def build_error_data(error_url, model, complement = {})
    translated_field = I18n.t("models.attributes.#{model}.#{complement[:field]}")
    error_message = I18n.t("errors.#{error_url}.message", field: translated_field)

    { message: error_message,
      index: I18n.t("errors.#{error_url}.index"),
      code: I18n.t("errors.#{error_url}.code") }
  end
end
