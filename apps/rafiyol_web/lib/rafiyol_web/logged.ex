defmodule RafiyolWeb.Logged do
  import Phoenix.Controller
  alias RafiyolWeb.Router.Helpers, as: Routes

  def init(params), do: params

  def call(conn, :notlogged) do
    if !Map.get(conn.assigns, :current_user) do
      conn
    else
      conn
      |> redirect(to: Routes.word_path(conn, :index))
    end
  end

  def call(conn, :logged) do
    if Map.get(conn.assigns, :current_user)  do
      conn
    else
      conn
      |> redirect(to: Routes.word_path(conn, :index))
    end
  end
end
