defmodule RafiyolWeb.WordView do
  use RafiyolWeb, :view

  use Phoenix.HTML

  def button_delete(conn, id) do
    button("Delete",
      to: Routes.word_path(conn, :delete, id),
      method: :delete,
      class: "btn btn-outline-danger"
    )
  end

  def button_edit(conn, id) do
    button("Edit", to: Routes.word_path(conn, :edit, id), method: :get, class: "btn btn-primary")
  end

  def button_cancel(conn) do
    button("Cancel",
      to: Routes.word_path(conn, :index),
      method: :get,
      class: "btn btn-danger float-end"
    )
  end

  def pagination_link_class(type, pos) do
    "page-link " <> pl_class(type, pos)
  end

  defp pl_class(:top, :left),      do: "border-bottom-0 rounded-top-left"
  defp pl_class(:top, :center),    do: "border-bottom-0"
  defp pl_class(:top, :right),     do: "border-bottom-0 rounded-top-right"
  defp pl_class(:bottom, :left),   do: "border-top-0 rounded-bottom-left"
  defp pl_class(:bottom, :center), do: "border-top-0"
  defp pl_class(:bottom, :right),  do: "border-top-0 rounded-bottom-right"

  def pages(center, limit, radius) do
    cond do
      center - radius < 0 and center + radius < limit ->
        pages(radius, limit, radius)
      center - radius > 0 and center + radius >= limit ->
        pages(limit-radius-1, limit, radius)
      center - radius < 0 and center + radius >= limit ->
        1..limit
      true ->
        (center-radius+1)..(center+radius+1)
    end
  end
end
