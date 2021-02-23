defmodule TvirusWeb.SurvivorView do
  use TvirusWeb, :view
  alias TvirusWeb.SurvivorView

  def render("index.json", %{survivors: survivors}) do
    %{data: render_many(survivors, SurvivorView, "survivor.json")}
  end

  def render("show.json", %{survivor: survivor}) do
    %{data: render_one(survivor, SurvivorView, "survivor.json")}
  end

  def render("survivor.json", %{survivor: survivor}) do
    inventory = prepare_inventory(survivor)

    %{
      id: survivor.id,
      name: survivor.name,
      age: survivor.age,
      gender: survivor.gender,
      last_location: %{
        latitude: survivor.latitude,
        longitude: survivor.longitude
      },
      infected: survivor.infected,
      inventory: inventory
    }
  end

  defp prepare_inventory(survivor) do
    neo_survivor = Tvirus.Repo.preload(survivor, [:inventory])

    %{
      fiji_water: count_items(neo_survivor.inventory, "Fiji Water"),
      campbell_soup: count_items(neo_survivor.inventory, "Campbell Soup"),
      first_aid_pouch: count_items(neo_survivor.inventory, "First Aid Pouch"),
      ak47: count_items(neo_survivor.inventory, "AK47")
    }
  end

  def count_items(inventory, item_name) do
    Enum.reduce(inventory, 0, fn item, acc -> if item.name == item_name, do: acc + 1, else: acc end)
  end
end
