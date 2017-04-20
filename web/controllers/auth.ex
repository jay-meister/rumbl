defmodule Rumbl.Auth do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def init(ops) do
    Keyword.fetch!(ops, :repo)
  end

  def call(conn, repo) do
    # get the user_id session from the session
    # look the user up, add user to the conn
    # conn.assigns.current_user
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(Rumbl.User, user_id)

    assign(conn, :current_user, user)
  end

  def login(conn, user) do
    # adds the user to the conn.assigns
    # add cookie to conn
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end


  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def login_by_username_and_pass(conn, username, given_pass, ops) do
    # function called with username and unhashed password and the repo
    # get the user from the db
    # check if the passwords match if the user is there
    # log them in by running login(conn, user)
    repo = Keyword.fetch!(ops, :repo)
    user = repo.get_by(Rumbl.User, username: username)
    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end
end
