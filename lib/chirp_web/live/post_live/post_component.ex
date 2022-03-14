defmodule ChirpWeb.PostLive.PostComponent do
  use ChirpWeb, :live_component
  alias Chirp.Timeline
  def render(assigns) do
    IO.puts("Rendering")
    IO.inspect(assigns.post.__meta__.state)
    ~H"""
    <div class="row"
    style={if @post.__meta__.state == :deleted, do: "display:none;", else: ""}
    >
          <div class="column">
          <%= @post.body %>
          <span>♥️:<%= @post.likes_count %></span>
          <span>♽: <%= @post.reposts_count %> </span>
          <span><%= live_patch "Edit", to: Routes.post_index_path(@socket, :edit, @post) %></span>
          <span><%= link "Delete", to: "#", phx_click: "delete", phx_target: @myself, phx_value_id: @post.id, data: [confirm: "Are you sure?"] %></span>
          <a href="#" phx-click="like" phx-target={@myself}> Like </a>
          <a href="#" phx-click="repost" phx-target={@myself}> repost </a>
          🗑: <%= if @post.__meta__.state == :deleted, do: "Yes", else: "No" %>
          </div>
    </div>

    """
  end

  def handle_event("like", _, socket) do
    Chirp.Timeline.inc_likes(socket.assigns.post)
    {:noreply, socket}
  end

  def handle_event("repost", _, socket) do
    Chirp.Timeline.inc_reposts(socket.assigns.post)
    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    post = Timeline.get_post!(id)
    {:ok, _} = Timeline.delete_post(post)
    {:noreply, socket}
  end

end
