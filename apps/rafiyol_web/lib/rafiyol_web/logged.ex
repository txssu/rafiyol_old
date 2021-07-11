defmodule RafiyolWeb.Logged do
  import Plug.Conn
  import Phoenix.Controller
  alias RafiyolWeb.Router.Helpers, as: Routes

  def init(params) when is_tuple(params), do: params

  def init(params), do: {params}

  def call(conn, {:notlogged}) do
    process(
      conn,
      !Map.get(conn.assigns, :current_user),
      &Routes.user_path(&1, :show, conn.assigns.current_user.id),
      true
    )
  end

  def call(conn, {:notlogged, [noflash: true]}) do
    process(
      conn,
      !Map.get(conn.assigns, :current_user),
      &Routes.user_path(&1, :show, conn.assigns.current_user.id),
      false
    )
  end

  def call(conn, {:logged}) do
    process(conn, Map.get(conn.assigns, :current_user), &Routes.page_path(&1, :index), true)
  end

  defp process(conn, state, action, flash) do
    if state do
      conn
    else
      conn
      |> flash_if_need(flash)
      |> redirect(to: action.(conn))
      |> halt()
    end
  end

  defp flash_if_need(conn, condx) do
    if condx do
      put_flash(conn, :error, "Access denied")
    else
      conn
    end
  end
end
