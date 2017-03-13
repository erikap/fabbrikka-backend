defmodule Dispatcher do
  use Plug.Router

  def start(_argv) do
    port = 80
    IO.puts "Starting Plug with Cowboy on port #{port}"
    Plug.Adapters.Cowboy.http __MODULE__, [], port: port
    :timer.sleep(:infinity)
  end

  plug Plug.Logger
  plug :match
  plug :dispatch

  # In order to forward the 'themes' resource to the
  # resource service, use the following forward rule.
  #
  # docker-compose stop; docker-compose rm; docker-compose up
  # after altering this file.
  #
  match "/api/products/*path" do
    Proxy.forward conn, path, "http://resource/products/"
  end

  match "/api/product-names/*path" do
    Proxy.forward conn, path, "http://resource/product-names/"
  end

  match "/api/product-descriptions/*path" do
    Proxy.forward conn, path, "http://resource/product-descriptions/"
  end

  match "/api/product-sizes/*path" do
    Proxy.forward conn, path, "http://resource/product-sizes/"
  end

  match "/api/product-prices/*path" do
    Proxy.forward conn, path, "http://resource/product-prices/"
  end

  match "/api/product-images/*path" do
    Proxy.forward conn, path, "http://resource/product-images/"
  end

  match "/api/files/*path" do
    Proxy.forward conn, path, "http://file-service/files/"
  end

  match "/api/product-audiences/*path" do
    Proxy.forward conn, path, "http://resource/product-audiences/"
  end

  match "/app/*path" do
      Proxy.forward conn, path, "http://ember/app/"
  end

  match _ do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end

end
