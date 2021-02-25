defmodule Tvirus.Utils do
  def atomify_map(%{} = map) do
    map
    |> Map.new(fn {k, v} -> {String.to_atom(k), atomify_map(v)} end)
  end

  def atomify_map(not_a_map), do: not_a_map

  def build_trade_key_value(k, v) do
    value = String.to_integer(v)
    map = %{
      ak47: "AK47",
      campbell_soup: "Campbell Soup",
      fiji_water: "Fiji Water",
      first_aid_pouch: "First Aid Pouch"
    }

    {map[k], value}
  end
end
