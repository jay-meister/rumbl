defmodule Rumbl.SessionController do
  use Rumbl.Web, :controller

  def create(conn, %{"session" => %{"username" => user, "password" => pass}}) do
    case Rumbl.Auth.login_by_username_and_pass(conn, user, pass, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "you are now logged in")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid username/password")
        |> render("new.html")
    end
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def delete(conn, _params) do
    conn
    |> Rumbl.Auth.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
