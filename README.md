# Tvirus
 
It’s a RESTfull API to play a game, as a solution for the proposed problem below. This solution may seem over-engineered, but I wanted it to show my skills as a back-end dev. The main idea was to have the cleanest code possible with TDD, scalability and maintainability in mind.

### Proposal Problem

  The world, as we know it, has fallen into an apocalyptic scenario. The Twiter Virus is transforming human beings into stupid beasts (a.k.a. Zombies), hungry to cancel humans and eat their limbs.

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

## Docker
- docker-compose build
- docker-compose run --rm web mix deps.get
- docker-compose run --rm web mix ecto.setup
- docker-compose run --rm web mix test
- docker-compose up --force-recreate

## Database
  PostgreSQL
  ```
  username: postgres
  password: postgres
  ```

## Using

 You can use postman, or a similar app, to send json to this API.The endpoint and the item's list are below.

  | Item              | Points    |
  |-------------------|-----------|
  | 1 Fiji Water      | 14 points |
  | 1 Campbell Soup   | 12 points |
  | 1 First Aid Pouch | 10 points |
  | 1 AK47            |  8 points |

### Endpoint

 - Add survivors ( post /api/v1/sign_up )
  ```
  {
    "survivor": {
      "name": "John One",
      "age": 23,
      "gender": "M",
      "last_location": {
        "latitude": "15.23456",
        "longitude": "-30.67890"
      },
      "inventory": [
        "Fiji Water",
        "Campbell Soup",
        "Campbell Soup",
        "First Aid Pouch",
        "AK47",
        "First Aid Pouch",
        "Campbell Soup"
      ]
    }
  }
  ```

 - Update survivor location ( put /api/v1/location/:id )
  ```
  {
    "last_location": {
      "latitude": "15.23456",
      "longitude": "-30.67890",
    }
  }
  ```

 - Flag survivor as infected ( put /api/v1/flag/:id )
  ```
  {
    "flager_id": 1
  }
  ```

 - Reports ( get api/v1/reports )

 - Trade items ( post /api/v1/trade_items )
  ```
  {
    "survivor_id_one": 1,
    "trade_one": {
      "fiji_water": 5,
      "campbell_soup": 0,
      "first_aid_pouch": 5,
      "ak47": 0
    },
    "survivor_id_two": 3,
    "trade_two": {
      "fiji_water": 0,
      "campbell_soup": 6,
      "first_aid_pouch": 0,
      "ak47": 6
    }
  }
  ```

## Made by

 - [mavmaso](https://github.com/mavmaso)
