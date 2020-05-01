defmodule BigCanvasLiveViewWeb.GridLive do
  use Phoenix.LiveView

  alias BigCanvasLiveView.Tiles
  
  def render(assigns) do
    ~L"""
    <div
      id="mycanvaswrapper"
      phx-hook="canvas"
      data-tiles="<%= Jason.encode!(@tiles) %>"
    >
      <canvas
        id="mycanvas"
        phx-update="ignore"
      >
        Canvas is not supported!
      </canvas>
    </div>
    """
  end
  
  def mount(_params, _session, socket) do
    Tiles.subscribe()

    {:ok, load_tiles(socket)}
  end

  #def handle_info(:update, %{assigns: %{tiles: tiles}} = socket) do
  def handle_info(:update, socket) do
    IO.puts(inspect(socket))
    {:noreply, load_tiles(socket)}
  end
  
  defp load_tiles(socket) do
    tiles = convert_tiles(Tiles.list_tiles())

    IO.puts(inspect(tiles))

    assign(socket, tiles: tiles)
  end

  defp convert_tiles(tiles) do
    tiles
    |> Map.new(fn tile -> {"#{tile.x},#{tile.y}", tile.body} end)
  end
end