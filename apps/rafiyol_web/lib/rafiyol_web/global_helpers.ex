defmodule RafiyolWeb.GlobalHelpers do
  use Phoenix.HTML

  import RafiyolWeb.ErrorHelpers

  def bootstarp_input_group(form, field, validation, name \\ nil) do
    [
      if name do label(form, field, name) else label(form, field) end,
      validate_text_input(form, field, validation),
      error_tag(form, field)
    ]
  end

  def validate_text_input(form, field, validation) do
    if Keyword.get_values(form.errors, field) == [] do
      if validation do
        text_input(form, field, class: "form-control is-valid")
      else
        text_input(form, field, class: "form-control")
      end
    else
      text_input(form, field, class: "form-control is-invalid")
    end
  end
end
