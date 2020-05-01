defmodule BigCanvasLiveView.Tiles do
  @moduledoc """
  The Tiles context.
  """

  import Ecto.Query, warn: false
  alias BigCanvasLiveView.Repo

  alias BigCanvasLiveView.Tiles.Tile

  @topic inspect(__MODULE__)

  @doc """
  Returns the list of tiles.

  ## Examples

      iex> list_tiles()
      [%Tile{}, ...]

  """
  def list_tiles do
    Repo.all(Tile)
  end

  @doc """
  Gets a single tile.

  Raises `Ecto.NoResultsError` if the Tile does not exist.

  ## Examples

      iex> get_tile!(123)
      %Tile{}

      iex> get_tile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tile!(id), do: Repo.get!(Tile, id)

  @doc """
  Creates a tile.

  ## Examples

      iex> create_tile(%{field: value})
      {:ok, %Tile{}}

      iex> create_tile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tile(attrs \\ %{}) do
    %Tile{}
    |> Tile.changeset(attrs)
    |> Repo.insert()
    |> broadcast_change([:tile, :created])
  end

  @doc """
  Updates a tile.

  ## Examples

      iex> update_tile(tile, %{field: new_value})
      {:ok, %Tile{}}

      iex> update_tile(tile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tile(%Tile{} = tile, attrs) do
    tile
    |> Tile.changeset(attrs)
    |> Repo.update()
    |> broadcast_change([:tile, :updated])
  end

  @doc """
  Deletes a tile.

  ## Examples

      iex> delete_tile(tile)
      {:ok, %Tile{}}

      iex> delete_tile(tile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tile(%Tile{} = tile) do
    tile
    |> Repo.delete()
    |> broadcast_change([:tile, :updated])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tile changes.

  ## Examples

      iex> change_tile(tile)
      %Ecto.Changeset{source: %Tile{}}

  """
  def change_tile(%Tile{} = tile) do
    Tile.changeset(tile, %{})
  end

  def subscribe do
    Phoenix.PubSub.subscribe(BigCanvasLiveView.PubSub, @topic)
  end

  defp broadcast_change({:ok, result}, event) do
    Phoenix.PubSub.broadcast(BigCanvasLiveView.PubSub, @topic, {__MODULE__, event, result})

    {:ok, result}
  end
end
