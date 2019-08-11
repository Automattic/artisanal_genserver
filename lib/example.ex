defmodule Bcn.Example do
  # swap out this ArtisanalGenServer for built-in
  # (use GenServer) and tests should still pass!
  alias Bcn.ArtisanalGenServer

  # Client API
  def start_link() do
    ArtisanalGenServer.start_link(__MODULE__, :ok)
  end

  def call(pid, value) do
    ArtisanalGenServer.call(pid, value)
  end

  def cast(pid, value) do
    ArtisanalGenServer.cast(pid, value)
    :ok
  end

  @doc """
  Retrieves the state from the genserver


  ## Examples

      iex> {:ok, pid} = Example.start_link()
      iex> Example.call(pid, 42)
      {:ok, "Received message: 42"}
      iex> Example.get_state(pid)
      {:ok, [42]}
  """
  def get_state(pid) do
    ArtisanalGenServer.call(pid, :get_state)
  end

  def stop_server(pid, reason \\ :normal) do
    ArtisanalGenServer.stop(pid, reason)
  end

  # Server
  def init(:ok) do
    {:ok, []}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call(value, _from, state) do
    {:reply, {:ok, "Received message: " <> to_string(value)}, [value | state]}
  end

  def handle_cast(value, state) do
    {:noreply, [value | state]}
  end

  def terminate(reason, _state) do
    IO.inspect(reason, label: "Terminate Reason: ")
  end
end
