defmodule Tvirus.SurvivorFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      def survivor_factory do
        %Tvirus.Player.Survivor{
          name: Faker.Person.PtBr.name(),
          age: :rand.uniform(99) + 1,
          gender: Enum.random(["M", "F"]),
          latitude: 15.12,
          longitude: -30.34,
          infected: false
        }
      end
    end
  end
end
