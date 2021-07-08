defmodule RafiyolWeb.GlobalHelpers do
  use Phoenix.HTML

  import RafiyolWeb.ErrorHelpers

  def bootstarp_input_group(form, field, type \\ :text, validation, name \\ nil)

  def bootstarp_input_group(form, field, type, validation, name) do
    label =
      if name do
        label(form, field, name)
      else
        label(form, field)
      end

    [
      label,
      input_with_validation(form, field, type, validation),
      error_tag(form, field)
    ]
  end

  def input_with_validation(form, field, :text, validation) do
    fun = &text_input(&1, &2, &3)
    generate_input(form, field, fun, validation)
  end

  def input_with_validation(form, field, :password, validation) do
    fun = &password_input(&1, &2, &3)
    generate_input(form, field, fun, validation)
  end

  def input_with_validation(form, field, :email, validation) do
    fun = &email_input(&1, &2, &3)
    generate_input(form, field, fun, validation)
  end

  defp generate_input(form, field, fun, validation) do
    if Keyword.get_values(form.errors, field) == [] do
      if validation do
        fun.(form, field, class: "form-control is-valid")
      else
        fun.(form, field, class: "form-control")
      end
    else
      fun.(form, field, class: "form-control is-invalid")
    end
  end
end
