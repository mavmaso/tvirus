defmodule TvirusWeb.Router do
  use TvirusWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", TvirusWeb do
    pipe_through :api

    post "/sign_up", SurvivorController, :sign_up
    put "/location/:id", SurvivorController, :location
    put "/flag/:id", SurvivorController, :flag
  end
end
