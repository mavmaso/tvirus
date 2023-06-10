{:ok, _} = Application.ensure_all_started(:ex_machina)
Mimic.copy(Tvirus.Repo)

ExUnit.start()
Faker.start()
Ecto.Adapters.SQL.Sandbox.mode(Tvirus.Repo, :manual)
