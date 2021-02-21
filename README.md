# Tvirus
 
  It's a RESTfull API for play a game, "The Resident Zombie', as a solution for proposal problem:

### Problem Description

  The world, as we know it, has fallen into an apocalyptic scenario. The "Influenzer T-Virus" (a.k.a. Twiter Virus) is transforming human beings into stupid beasts (a.k.a. Zombies), hungry to cancel humans and eat their limbs.

  You, the last survivor who knows how to code, will help the resistance by deploying a system to connect the remaining humans. This system will be essential to detect new infections and share resources between the members.

## Deps for Linux

- `sudo apt update`
- `sudo apt upgrade`
- `sudo apt install -y build-essential libssl-dev zlib1g-dev automake autoconf libncurses5-dev`

## In loco Setup

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server`
- Run complete tests `mix test`

## Database
  PostgreSQL
  ```
  username: postgres
  password: postgres
  ```

## Using

 WIP

### Endpoint

 - Add survivors ( post /api/v1/sign_up )
  ```
  {
    "name": "John One",
    "age": 23,
    "gender": "M",
    "last_location": {
      "latitude": 15.23456,
      "longitude": -30.67890
    }
    inventory: {
      fiji_water: 1,
      campbell_soup: 2,
      first_aid_pouch: 0,
      AK47: 1
    }
  }
  ```

 - Update survivor location ( put /api/v1/location/:id )
  ```
  {
    "latitude": 37.421925,
    "longitude": -122.0841293
  }
  ```

 - Flag survivor as infected ( put /api/v1/flag/:id )

 - Trade items ( post /api/v1/trade/ )
  ```
  {
    survivor_id: 2
    inventory: {
      fiji_water: 5,
      campbell_soup: 0,
      first_aid_pouch: 5,
      AK47: 0
    },
    survivor_id: 3
    inventory: {
      fiji_water: 0,
      campbell_soup: 6,
      first_aid_pouch: 0,
      AK47: 6
    }
  }
  ```

 - Reports - infected  ( get api/v1/infecteds )

 - Reports - non-infected ( get api/v1/healths )

 - Reports - average amount items by survivors ( get api/v1/items_by_survivors )

 - Reports - points lost because of an infected survivor ( get api/v1/lost_points )


## Made by

 - [mavmaso](https://github.com/mavmaso)
