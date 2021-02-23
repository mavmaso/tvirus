defmodule Tvirus.Repo.Migrations.AddUniqueNameSurvivors do
  use Ecto.Migration

  def change do
    create unique_index(:survivors, [:name])
  end
end
