defmodule RafiyolWeb.Logged do
  import Plug.Conn
  import Phoenix.Controller
  alias RafiyolWeb.Router.Helpers, as: Routes

  def init(params), do: params

  def call(conn, :notlogged) do
    process(conn, !Map.get(conn.assigns, :current_user))
  end

  def call(conn, :logged) do
    process(conn, Map.get(conn.assigns, :current_user))
  end

  defp process(conn, state) do
    if state do
      conn
    else
      conn
      |> put_flash(:error, "Access denied")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
