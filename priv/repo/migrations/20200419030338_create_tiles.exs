defmodule BigCanvasLiveView.Repo.Migrations.CreateTiles do
  use Ecto.Migration

  def change do
    create table(:tiles) do
      add :x, :integer
      add :y, :integer
      add :body, :text

      timestamps()
    end

  end
end
