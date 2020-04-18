defmodule BigCanvasLiveViewWeb.PageController do
  use BigCanvasLiveViewWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
