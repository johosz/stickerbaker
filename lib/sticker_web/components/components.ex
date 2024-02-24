defmodule StickerWeb.Components do
  use StickerWeb, :html

  attr :id, :string, required: true
  attr :class, :string, default: nil
  attr :prediction, :map, required: true

  def sticker(assigns) do
    ~H"""
    <div class={@class}>
      <.image id={@id} prediction={@prediction} />
    </div>
    """
  end

  defp image(assigns) do
    ~H"""
    <.link navigate={~p"/sticker/#{@prediction.id}"}>
      <div class="group aspect-h-10 aspect-w-10 block overflow-hidden rounded-lg bg-gray-100 focus-within:ring-2 focus-within:ring-black-500 focus-within:ring-offset-2 focus-within:ring-offset-gray-100">
        <%= if is_nil(@prediction.sticker_output) and is_nil(@prediction.no_bg_output) do %>
          <div class="flex items-center justify-center h-36">
            <p class="animate-pulse ">Loading...</p>
          </div>
        <% else %>
          <button
            id={"prediction-#{@id}-btn"}
            phx-value-name={@prediction.prompt |> humanize()}
            phx-value-image={@prediction.no_bg_output || @prediction.sticker_output}
            type="button"
          >
            <img
              src={@prediction.no_bg_output || @prediction.sticker_output}
              alt={@prediction.prompt}
              class="pointer-events-none object-cover group-hover:opacity-75"
            />
          </button>
        <% end %>
      </div>

      <span class="mt-2 block truncate text-sm font-medium text-gray-900">
        <%= @prediction.prompt %>
      </span>
    </.link>
    """
  end

  defp feedback(assigns) do
    ~H"""
    <div class={"flex justify-between items-center feedback-#{@prediction.id}"}>
      <button
        id={"thumbs-up-#{@prediction.id}"}
        phx-click={JS.hide(to: ".feedback-#{@prediction.id}") |> JS.push("thumbs-up")}
        phx-value-id={@prediction.id}
        class="rounded-full bg-gray-50 mt-2"
      >
        <img class="h-12" src="/images/thumbs-up.png" alt="" />
      </button>
      <button
        id={"thumbs-down-#{@prediction.id}"}
        phx-value-id={@prediction.id}
        phx-click={JS.hide(to: ".feedback-#{@prediction.id}") |> JS.push("thumbs-down")}
        class="rounded-full  mt-2 rotate-180"
      >
        <img class="h-12" src="/images/thumbs-up.png" alt="" />
      </button>
    </div>
    """
  end

  defp humanize(name) do
    Sticker.Utils.humanize(name)
  end
end