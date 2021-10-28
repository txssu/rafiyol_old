defmodule RafiyolWeb.WordView do
  use RafiyolWeb, :view

  use Phoenix.HTML

  def button_delete(conn, id) do
    button("Delete", to: Routes.word_path(conn, :delete, id), method: :delete, class: "btn btn-outline-danger")
  end

  def button_edit(conn, id) do
    button("Edit", to: Routes.word_path(conn, :edit, id), method: :get, class: "btn btn-outline-primary")
  end

  def button_cancel(conn) do
    button("Cancel", to: Routes.word_path(conn, :index), method: :get, class: "btn btn-danger float-end")
  end
end
