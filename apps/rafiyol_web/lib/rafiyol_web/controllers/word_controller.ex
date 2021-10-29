defmodule RafiyolWeb.WordController do
  use RafiyolWeb, :controller

  plug RafiyolWeb.Logged, :logged

  def index(conn, params) do
    offset =
      case Map.get(params, "offset", "0") |> Integer.parse() do
        {num, _error} -> max(num, 0)
        :error -> 0
      end

    words = Rafiyol.list_users_recent_words(conn.assigns.current_user.id, offset * 10)

    render(conn, "index.html",
      words: words,
      offset: offset,
      max_offset: Rafiyol.words_count(),
      page_name: "Recently words"
    )
  end

  def show(conn, %{"id" => id}) do
    word = Rafiyol.get_word(id)
    render(conn, "show.html", word: word, page_name: word.self)
  end

  def new(conn, _params) do
    word = Rafiyol.new_word()
    render(conn, "new.html", changeset: word, page_name: "Add word")
  end

  def create(conn, %{"word" => word_params}) do
    user_id = conn.assigns.current_user.id
    word_params = Map.put(word_params, "user_id", user_id)

    case Rafiyol.insert_word(word_params) do
      {:ok, _} ->
        redirect(conn, to: Routes.word_path(conn, :new))

      {:error, word} ->
        conn
        |> put_flash(
          :error,
          "Unfortunately, there are errors in your submission. Please correct them below."
        )
        |> render("new.html", changeset: word, page_name: "Add word")
    end
  end

  def edit(conn, %{"id" => id}) do
    word = Rafiyol.edit_word(id)
    render(conn, "edit.html", changeset: word, page_name: "Edit word")
  end

  def update(conn, %{"id" => id, "word" => word_params}) do
    word = Rafiyol.get_word(id)

    case Rafiyol.update_word(word, word_params) do
      {:ok, word} ->
        redirect(conn, to: Routes.word_path(conn, :show, word))

      {:error, word} ->
        conn
        |> put_flash(
          :error,
          "Unfortunately, there are errors in your submission. Please correct them below."
        )
        |> render("new.html", changeset: word, page_name: "Edit word")
    end
  end

  def delete(conn, %{"id" => id}) do
    case Rafiyol.delete_word(id) do
      {:ok, _} ->
        redirect(conn, to: Routes.word_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Something get wrong")
        |> redirect(to: Routes.word_path(conn, :index))
    end
  end
end
