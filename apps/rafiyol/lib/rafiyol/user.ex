defmodule Rafiyol.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:username, :email, :hashed_password])
    |> validate_required([:username, :email, :hashed_password])
    |> validate_length(:username, min: 3)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end

  def changeset_with_password(user, params \\ %{}) do
    user
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 5)
    |> validate_confirmation(:password, required: true)
    |> hash_password()
    |> changeset(params)
  end

  defp hash_password(%Ecto.Changeset{changes: %{password: password}} = changeset) do
    changeset
    |> put_change(:hashed_password, Rafiyol.Password.hash(password))
  end

  defp hash_password(changeset), do: changeset
end
