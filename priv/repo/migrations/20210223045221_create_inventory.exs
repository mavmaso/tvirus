defmodule Tvirus.Repo.Migrations.CreateInventory do
  use Ecto.Migration

  def change do
    create table(:inventory) do
      add :survivor_id, references(:survivors, on_delete: :delete_all)
      add :item_id, references(:items, on_delete: :delete_all)
    end
  end
end
