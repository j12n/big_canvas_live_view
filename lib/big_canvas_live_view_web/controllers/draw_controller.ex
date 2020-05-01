defmodule BigCanvasLiveViewWeb.DrawController do
  use BigCanvasLiveViewWeb, :controller

  import Ecto.Query, warn: false
  alias BigCanvasLiveView.Repo
  alias BigCanvasLiveView.Tiles
  alias BigCanvasLiveView.Tiles.Tile

  def index(conn, %{"x" => x, "y" => y}) do
    IO.puts("x ~ #{x} and y ~ #{y}")
    render(conn, "index.html", x: x, y: y)
  end

  def create(conn, %{"x" => x, "y" => y, "data" => data} = params) do
    result =
      Repo.all(from t in Tile,
                where: t.x == ^x and t.y == ^y)
      |> List.first()

    save_tile(result, %{x: x, y: y, body: Jason.encode!(data)})

    conn
    |> send_resp(201, "")  
  end

  defp save_tile(nil, attrs) do
    IO.puts('create')
    Tiles.create_tile(attrs)    
  end

  defp save_tile(%Tile{} = tile, attrs) do
    IO.puts('update')
    Tiles.update_tile(tile, attrs)        
  end
end