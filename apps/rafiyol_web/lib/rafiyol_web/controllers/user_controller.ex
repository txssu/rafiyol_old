defmodule RafiyolWeb.UserController do
  use RafiyolWeb, :controller

  plug :only_own_profile when action in [:show]
  plug RafiyolWeb.Logged, :notlogged when action in [:new]
  plug RafiyolWeb.Logged, :logged when action in [:edit]

  def show(conn, %{"id" => id}) do
    user = Rafiyol.edit_user(id)
    render(conn, "show.html", changeset: user, page_name: conn.assigns.current_user.username)
  end

  def new(conn, _params) do
    changeset = Rafiyol.new_user()
    render(conn, "new.html", changeset: changeset, page_name: "Registration")
  end

  def create(conn, %{"user" => user_params}) do
    case Rafiyol.insert_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Account successful created")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, changeset} ->
        conn
        |> put_flash(
          :error,
          "Unfortunately, there are errors in your submission. Please correct them below."
        )
        |> render("new.html", changeset: changeset, page_name: "Registration")
    end
  end

  def update(conn, %{
        "user" => updates = %{"password" => password}
      }) do
    current_user = conn.assigns.current_user

    case Rafiyol.get_user_by_username_and_password(current_user.username, password) do
      %Rafiyol.User{} ->
        case Rafiyol.update_user(current_user, updates) do
          {:ok, user} ->
            redirect(conn, to: Routes.user_path(conn, :show, user.id))

          {:error, user} ->
            conn
            |> put_flash(
              :error,
              "Unfortunately, there are errors in your submission. Please correct them below."
            )
            |> render("show.html", changeset: user, page_name: conn.assigns.current_user.username)
        end

      _ ->
        user = Rafiyol.edit_user(current_user.id)

        conn
        |> put_flash(:error, "Password is incorrect")
        |> render("show.html", changeset: user, page_name: conn.assigns.current_user.username)
    end
  end

  defp only_own_profile(conn, _) do
    id =
      conn.params
      |> Map.get("id")
      |> String.to_integer()

    if conn.assigns.current_user != nil || conn.assigns.current_user[:id] == id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot see this profile")
      |> redirect(to: Routes.word_path(conn, :index))
      |> halt()
    end
  end
end
