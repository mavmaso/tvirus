defmodule Tvirus.Factory do
  use ExMachina.Ecto, repo: Tvirus.Repo

  use Tvirus.SurvivorFactory
  use Tvirus.ItemFactory
  use Tvirus.InventoryFactory
end
