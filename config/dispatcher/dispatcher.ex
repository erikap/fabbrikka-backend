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
  match "/products/*path" do
    Proxy.forward conn, path, "http://resource/products/"
  end

  match "/product-names/*path" do
    Proxy.forward conn, path, "http://resource/product-names/"
  end

  match "/product-descriptions/*path" do
    Proxy.forward conn, path, "http://resource/product-descriptions/"
  end

  match "/product-variants/*path" do
    Proxy.forward conn, path, "http://resource/product-variants/"
  end

  match "/product-variant-sizes/*path" do
    Proxy.forward conn, path, "http://resource/product-variant-sizes/"
  end

  match "/product-images/*path" do
    Proxy.forward conn, path, "http://resource/product-images/"
  end

  match "/files/*path" do
    Proxy.forward conn, path, "http://file-service/files/"
  end

  match "/product-audiences/*path" do
    Proxy.forward conn, path, "http://resource/product-audiences/"
  end

  match "/shopping-carts/*path" do
    Proxy.forward conn, path, "http://resource/shopping-carts/"
  end

  match "/shopping-cart-items/*path" do
    Proxy.forward conn, path, "http://resource/shopping-cart-items/"
  end

  match "/fabbrikka-locale-guesser/*path" do
    Proxy.forward conn, path, "http://fabbrikka-locale-guesser/"
  end

  match "/fabbrikka-cart-service/*path" do
    Proxy.forward conn, path, "http://fabbrikka-cart-service/"
  end

  match "/accounts/*path" do
    Proxy.forward conn, path, "http://registration/accounts/"
  end

  match "/sessions/*path" do
    Proxy.forward conn, path, "http://login/sessions/"
  end

  match _ do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end

end
