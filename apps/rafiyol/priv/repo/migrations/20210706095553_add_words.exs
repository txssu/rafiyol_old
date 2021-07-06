defmodule Rafiyol.Repo.Migrations.AddWords do
  use Ecto.Migration

  def change do
    create table(:words) do
      add :self, :string
      add :translation, :string
      timestamps()
    end

    create index(:words, :self)
    create index(:words, :translation)
  end
end
