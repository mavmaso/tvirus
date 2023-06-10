defmodule Tvirus.Repo.Migrations.CreateSurvivors do
  use Ecto.Migration

  def change do
    create table(:survivors) do
      add :name, :string
      add :age, :integer
      add :gender, :string
      add :latitude, :float
      add :longitude, :float
      add :infected, :boolean

      timestamps()
    end
  end
end
