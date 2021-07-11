defmodule Rafiyol.Repo.Migrations.WordsLearn do
  use Ecto.Migration

  def change do
    alter table(:words) do
      add :next_repeat, :date
      add :level, :integer
    end
  end
end
