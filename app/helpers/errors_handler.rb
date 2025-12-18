module ErrorsHandler
  def build_error(error_url, complement: {})
    I18n.t("errors.#{error_url}", **complement)
  end
end
