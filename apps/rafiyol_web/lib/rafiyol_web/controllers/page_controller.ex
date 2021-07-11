defmodule RafiyolWeb.PageController do
  use RafiyolWeb, :controller

  plug RafiyolWeb.Logged, {:notlogged, [noflash: true]}

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
