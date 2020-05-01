defmodule BigCanvasLiveView.Tiles.Tile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tiles" do
    field :body, :string
    field :x, :integer
    field :y, :integer

    timestamps()
  end

  @doc false
  def changeset(tile, attrs) do
    tile
    |> cast(attrs, [:x, :y, :body])
    |> validate_required([:x, :y, :body])
  end
end
