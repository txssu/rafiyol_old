defmodule RafiyolWeb.PageController do
  use RafiyolWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
