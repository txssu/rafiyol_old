defmodule Rafiyol.Word do
  use Ecto.Schema

  import Ecto.Changeset

  schema "words" do
    field :self, :string
    field :translation, :string
    timestamps()
  end

  def changeset(word, params \\ %{}) do
    word
    |> cast(params, [:self, :translation])
    |> validate_required([:self, :translation])
  end
end
