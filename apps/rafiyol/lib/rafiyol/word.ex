defmodule Rafiyol.Word do
  use Ecto.Schema

  import Ecto.Changeset

  schema "words" do
    field :self, :string
    field :translation, :string
    belongs_to :user, Rafiyol.User
    timestamps()
  end

  def changeset(word, params \\ %{}) do
    word
    |> cast(params, [:self, :translation, :user_id])
    |> validate_required([:self, :translation])
    |> assoc_constraint(:user)
  end
end
