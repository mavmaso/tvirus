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

  def render("report.json", %{report: report}) do
    %{data: report}
  end
end
