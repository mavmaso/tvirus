defmodule Tvirus.Factory do
  use ExMachina.Ecto, repo: Tvirus.Repo

  use Tvirus.SurvivorFactory
end
