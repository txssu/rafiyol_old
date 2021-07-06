defmodule RafiyolWeb.WordController do
  use RafiyolWeb, :controller

  def index(conn, _params) do
    words = Rafiyol.list_recent_words()
    render(conn, "index.html", words: words)
  end

  def show(conn, %{"id" => id}) do
    word = Rafiyol.get_word(id)
    render(conn, "show.html", word: word)
  end

  def new(conn, _params) do
    word = Rafiyol.new_word()
    render(conn, "new.html", changeset: word)
  end

  def create(conn, %{"word" => word_params}) do
    case Rafiyol.insert_word(word_params) do
      {:ok, word} ->
        redirect(conn, to: Routes.word_path(conn, :show, word))

      {:error, word} ->
        conn
        |> put_flash(
          :error,
          "Unfortunately, there are errors in your submission. Please correct them below."
        )
        |> render("new.html", changeset: word)
    end
  end

  def edit(conn, %{"id" => id}) do
    word = Rafiyol.edit_word(id)
    render(conn, "edit.html", changeset: word)
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
        |> render("new.html", changeset: word)
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
