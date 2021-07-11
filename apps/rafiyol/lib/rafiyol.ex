defmodule Rafiyol do
  @moduledoc """
  Rafiyol keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Rafiyol.{User, Word, Repo, Password, LearnSession}

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

  def list_users_recent_words(user_id) do
    query =
      from w in Word,
        where: ^user_id == w.user_id,
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

  def edit_user(id) do
    get_user(id)
    |> User.changeset()
  end

  def update_user(%User{} = user, updates) do
    user
    |> User.changeset(updates)
    |> Repo.update()
  end

  def create_learn_session(user_id, words) do
    LearnSession.create_session(user_id, words)
  end

  def learn_session_next_word(user_id) do
    LearnSession.next_word(user_id)
  end

  def learn_session_word_again(user_id, word) do
    LearnSession.again(user_id, word)
  end

  def finish_learn_session(user_id) do
    LearnSession.delete_session(user_id)
  end
end
