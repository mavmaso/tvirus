fiji = Tvirus.Repo.insert!(%Tvirus.Resource.Item{name: "Fiji Water", points: 14})
soup = Tvirus.Repo.insert!(%Tvirus.Resource.Item{name: "Campbell Soup", points: 12})
aid = Tvirus.Repo.insert!(%Tvirus.Resource.Item{name: "First Aid Pouch", points: 10})
ak = Tvirus.Repo.insert!(%Tvirus.Resource.Item{name: "AK47", points: 8})

Tvirus.Repo.insert!(%Tvirus.Player.Survivor{
  name: "John ",
  age: 23,
  gender: "M",
  latitude: 15.12,
  longitude: -30.34,
  infected: false,
  inventory: [fiji,fiji,fiji,fiji,fiji,fiji, aid, aid, aid, aid, aid]
})

Tvirus.Repo.insert!(%Tvirus.Player.Survivor{
  name: "Cristina ",
  age: 42,
  gender: "F",
  latitude: 15.12,
  longitude: -30.34,
  infected: false,
  inventory: [ak,ak,ak,ak,ak,ak,ak,ak, soup,soup,soup,soup,soup,soup]
})
