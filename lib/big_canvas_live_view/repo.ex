defmodule BigCanvasLiveView.Repo do
  use Ecto.Repo,
    otp_app: :big_canvas_live_view,
    adapter: Ecto.Adapters.Postgres
end
