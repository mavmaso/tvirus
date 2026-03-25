defmodule TvirusWeb.SurvivorJSON do
  def index(%{survivors: survivors}), do: %{data: Enum.map(survivors, &data/1)}
  def show(%{survivor: survivor}), do: %{data: data(survivor)}
  def report(%{report: report}), do: %{data: report}

  defp data(survivor) do
    inventory = Tvirus.Player.build_inventory(survivor)

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
end
