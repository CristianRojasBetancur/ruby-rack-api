module ValidationSupport
  def validate_field(condition, error_url, complement = {})
    translated_field = translate_field(complement[:field])
    error_message = I18n.t("#{error_url}.message", field: translated_field, count: complement[:count])

    @errors << error_data(error_message, error_url) if condition
  end

  def valid?
    @errors.clear
    validate
    @errors.empty?
  end

  private

  def translate_field(field)
    I18n.t("models.attributes.#{self.class.name.downcase}.#{field}")
  end

  def error_data(message, error_url)
    {
      message: message,
      index: I18n.t("#{error_url}.index"),
      code: I18n.t("#{error_url}.code")
    }
  end
end
