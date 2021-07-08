defmodule RafiyolWeb.UserController do
  use RafiyolWeb, :controller

  plug :only_own_profile when action in [:show]
  plug RafiyolWeb.Logged, :notlogged when action in [:new]

  def show(conn, %{"id" => id}) do
    user = Rafiyol.get_user(id)
    render(conn, "show.html", user: user)
  end

  def new(conn, _params) do
    changeset = Rafiyol.new_user()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Rafiyol.insert_user(user_params) do
      {:ok, user} ->
        redirect(conn, to: Routes.user_path(conn, :show, user))

      {:error, changeset} ->
        conn
        |> put_flash(
          :error,
          "Unfortunately, there are errors in your submission. Please correct them below."
        )
        |> render("new.html", changeset: changeset)
    end
  end

  defp only_own_profile(conn, _) do
    id =
      conn.params
      |> Map.get("id")
      |> String.to_integer()

    if Map.get(conn.assigns.current_user, :id) == id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot see this profile")
      |> redirect(to: Routes.word_path(conn, :index))
      |> halt()
    end
  end
end
