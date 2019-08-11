defmodule Bcn.ArtisanalGenServer do
  @moduledoc """
  The Barcelona Artisanal GenServer is like a gen_server, but with extra
  artisan sauce.

  Crafted with love by team Lighthouse.
  """

  # API
  def start_link(module, args) do
    {:ok, spawn(__MODULE__, :server_init, [module, args])}
  end

  def call(server_pid, request) do
    send(server_pid, {:call, self(), request})

    receive do
      {:response, response} -> response
    end
  end

  def cast(server_pid, request) do
    send(server_pid, {:cast, request})
  end

  def stop(server_pid, reason \\ :normal) do
    send(server_pid, {:stop, reason})
  end

  # Core
  def server_init(module, args) do
    {:ok, state} = module.init(args)
    loop(module, state)
  end

  defp loop(module, state) do
    receive do
      {:call, parent_pid, request} ->
        {:reply, response, new_state} = module.handle_call(request, parent_pid, state)
        send(parent_pid, {:response, response})
        loop(module, new_state)

      {:cast, request} ->
        {:noreply, new_state} = module.handle_cast(request, state)
        loop(module, new_state)

      {:stop, reason} ->
        module.terminate(reason, state)
        exit(reason)

      request ->
        {:noreply, new_state} = module.handle_info(request, state)
        loop(module, new_state)
    end
  end
end
