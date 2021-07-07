defmodule RafiyolWeb.Authenticator do
  import Plug.Conn

  def init(_), do: nil

  def call(conn, _) do
    user =
      conn
      |> get_session(:user_id)
      |> case do
        nil -> nil
        id -> Rafiyol.get_user(id)
      end

    assign(conn, :current_user, user)
  end
end
