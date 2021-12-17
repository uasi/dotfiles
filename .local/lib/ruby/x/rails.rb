module XRails
  module_function

  def callbacks(model_class, callback_types = nil)
    callback_types ||= %i[validation initialize find touch save create update destroy]
    callback_types.map { |type| model_class.public_send("_#{type}_callbacks") }
  end

  def save_callbacks_pp(filename, model_class, callback_types = nil)
    IO.write(filename, PP.pp(callbacks(model_class, callback_types), ''))
  end
end
