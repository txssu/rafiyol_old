defmodule RafiyolWeb.LearnController do
  use RafiyolWeb, :controller

  plug RafiyolWeb.Logged, :logged

  def show(conn, _params) do
    render(conn, "show.html")
  end

  def create(conn, _params) do
    user_id = conn.assigns.current_user.id

    words =
      Rafiyol.list_users_words_for_learning(user_id)
      |> Enum.shuffle()

    Rafiyol.create_learn_session(user_id, words)
    redirect(conn, to: Routes.learn_path(conn, :edit))
  end

  def edit(conn, _params) do
    case Rafiyol.learn_session_next_word(conn.assigns.current_user.id) do
      :finish ->
        IO.inspect("WHAT")
        redirect(conn, to: Routes.learn_path(conn, :delete))

      word ->
        render(conn, "edit.html", word: word)
    end
  end

  def update(conn, %{"word" => %{"state" => state, "word_id" => word_id}}) do
    case state do
      "again" ->
        Rafiyol.learn_session_word_again(conn.assigns.current_user.id, Rafiyol.get_word(word_id))
        Rafiyol.reset_word_level(word_id)

      "good" ->
        Rafiyol.increse_word_level(word_id)
    end

    redirect(conn, to: Routes.learn_path(conn, :edit))
  end

  def delete(conn, _params) do
    render(conn, "delete.html")
  end
end
