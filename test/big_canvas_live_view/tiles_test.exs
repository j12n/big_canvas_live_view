defmodule BigCanvasLiveView.TilesTest do
  use BigCanvasLiveView.DataCase

  alias BigCanvasLiveView.Tiles

  describe "tiles" do
    alias BigCanvasLiveView.Tiles.Tile

    @valid_attrs %{body: "some body", x: 42, y: 42}
    @update_attrs %{body: "some updated body", x: 43, y: 43}
    @invalid_attrs %{body: nil, x: nil, y: nil}

    def tile_fixture(attrs \\ %{}) do
      {:ok, tile} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tiles.create_tile()

      tile
    end

    test "list_tiles/0 returns all tiles" do
      tile = tile_fixture()
      assert Tiles.list_tiles() == [tile]
    end

    test "get_tile!/1 returns the tile with given id" do
      tile = tile_fixture()
      assert Tiles.get_tile!(tile.id) == tile
    end

    test "create_tile/1 with valid data creates a tile" do
      assert {:ok, %Tile{} = tile} = Tiles.create_tile(@valid_attrs)
      assert tile.body == "some body"
      assert tile.x == 42
      assert tile.y == 42
    end

    test "create_tile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tiles.create_tile(@invalid_attrs)
    end

    test "update_tile/2 with valid data updates the tile" do
      tile = tile_fixture()
      assert {:ok, %Tile{} = tile} = Tiles.update_tile(tile, @update_attrs)
      assert tile.body == "some updated body"
      assert tile.x == 43
      assert tile.y == 43
    end

    test "update_tile/2 with invalid data returns error changeset" do
      tile = tile_fixture()
      assert {:error, %Ecto.Changeset{}} = Tiles.update_tile(tile, @invalid_attrs)
      assert tile == Tiles.get_tile!(tile.id)
    end

    test "delete_tile/1 deletes the tile" do
      tile = tile_fixture()
      assert {:ok, %Tile{}} = Tiles.delete_tile(tile)
      assert_raise Ecto.NoResultsError, fn -> Tiles.get_tile!(tile.id) end
    end

    test "change_tile/1 returns a tile changeset" do
      tile = tile_fixture()
      assert %Ecto.Changeset{} = Tiles.change_tile(tile)
    end
  end
end
