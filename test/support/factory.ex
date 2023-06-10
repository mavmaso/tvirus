defmodule Tvirus.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Tvirus.Repo

  use Tvirus.SurvivorFactory
  use Tvirus.ItemFactory
  use Tvirus.InventoryFactory
end
