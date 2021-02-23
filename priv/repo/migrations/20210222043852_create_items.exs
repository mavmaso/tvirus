defmodule Tvirus.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :points, :integer

      timestamps()
    end

    create unique_index(:items, [:name])
  end
end
