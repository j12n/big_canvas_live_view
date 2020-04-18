defmodule BigCanvasLiveViewWeb.TestLive do
  use Phoenix.LiveView
  
  def render(assigns) do
    ~L"""
    <div>
      <h2>Hello, <%= @name %>!</h2>
    </div>
    """
  end
  
  def mount(_params, _session, socket) do
    {:ok, assign(socket, name: "world")}
  end      
end