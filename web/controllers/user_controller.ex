defmodule Rumbl.UserController do
  use Rumbl.Web, :controller

  def index(conn, params) do
    users = Repo.all(Rumbl.User)
    conn |> render("index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(Rumbl.User, id)
    conn |> render("show.html", user: user)
  end

end
