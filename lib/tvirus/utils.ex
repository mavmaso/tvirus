defmodule Tvirus.Utils do
  def atomify_map(%{} = map) do
    map
    |> Map.new(fn {k, v} -> {String.to_atom(k), atomify_map(v)} end)
  end

  def atomify_map(not_a_map), do: not_a_map

  def build_trade_key_value(k, v) when is_integer(v) do
    map = %{
      ak47: "AK47",
      campbell_soup: "Campbell Soup",
      fiji_water: "Fiji Water",
      first_aid_pouch: "First Aid Pouch"
    }

    {map[k], v}
  end

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

  def fix_trade_map(%{ak47: a, campbell_soup: c, fiji_water: f, first_aid_pouch: p}) do
    %{
      ak47: (if is_integer(a), do: a, else: String.to_integer(a)),
      campbell_soup: (if is_integer(c), do: c, else: String.to_integer(c)),
      fiji_water: (if is_integer(f), do: f, else: String.to_integer(f)),
      first_aid_pouch: (if is_integer(p), do: p, else: String.to_integer(p))
    }
  end
end
