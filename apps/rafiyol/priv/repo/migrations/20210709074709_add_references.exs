defmodule Rafiyol.Repo.Migrations.AddReferences do
  use Ecto.Migration

  def change do
    alter table(:words) do
      add :user_id, references(:users)
    end
  end
end
