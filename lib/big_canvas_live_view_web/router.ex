defmodule BigCanvasLiveViewWeb.Router do
  use BigCanvasLiveViewWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {BigCanvasLiveViewWeb.LayoutView, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BigCanvasLiveViewWeb do
    pipe_through :browser

    get "/", PageController, :index

    live "/test", TestLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", BigCanvasLiveViewWeb do
  #   pipe_through :api
  # end
end
