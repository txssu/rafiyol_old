defmodule Rafiyol do
  @moduledoc """
  Rafiyol keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Rafiyol.{User, Word, Repo, Password}

  import Ecto.Query

  def new_word do
    %Word{}
    |> Word.changeset()
  end

  def list_words do
    Repo.all(Word)
  end

  def list_recent_words do
    query =
      from w in Word,
        order_by: [desc: :inserted_at],
        limit: 10

    Repo.all(query)
  end

  def get_word(id) do
    Repo.get(Word, id)
  end

  def get_word_by(params) do
    Repo.get_by(Word, params)
  end

  def insert_word(attrs) do
    %Word{}
    |> Word.changeset(attrs)
    |> Repo.insert()
  end

  def edit_word(id) do
    get_word(id)
    |> Word.changeset()
  end

  def update_word(%Word{} = item, updates) do
    item
    |> Word.changeset(updates)
    |> Repo.update()
  end

  def delete_word(id) do
    Repo.delete(id)
  end

  def new_user do
    %User{}
    |> User.changeset_with_password()
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def insert_user(attrs) do
    %User{}
    |> User.changeset_with_password(attrs)
    |> Repo.insert()
  end

  def get_user_by_username_and_password(username, password) do
    with user when not is_nil(user) <- Repo.get_by(User, %{username: username}),
         true <- Password.verify_with_hash(password, user.hashed_password) do
      user
    else
      _ -> Password.dummy_verify()
    end
  end
end
