defmodule Tvirus.SurvivorFactory do
  defmacro __using__(_opts) do
    # quote do
    #   def survivor_factory do
    #     %Tvirus.Player.Survivor{
    #       name: Faker.Person.PtBr.name(),
    #       age: (:rand.uniform(99) + 1),
    #       gender: Enum.random(["M", "F"]),
    #       last_location: %{
    #         latitude: 15.12,
    #         longitude: -30.34
    #       }
    #     }
    #   end
    # end
  end
end
