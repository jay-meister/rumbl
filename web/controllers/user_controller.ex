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

  def new(conn, _params) do
    changeset = Rumbl.User.changeset(%Rumbl.User{}, %{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_data}) do
    changeset = Rumbl.User.changeset(%Rumbl.User{}, user_data)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        IO.inspect changeset
        conn
        |> render("new.html", changeset: changeset)
    end

  end

end
