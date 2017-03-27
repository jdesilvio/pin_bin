defmodule Blaces.UserController do
  use Blaces.Web, :controller

  alias Blaces.User

  plug :scrub_params, "user" when action in [:create]

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, :show, user: user)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, :new, changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = %User{} |> User.registration_changeset(user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Blaces.Auth.login(user)
        |> put_flash(:info, "#{user.username} created!")
        |> redirect(to: user_path(conn, :show, user))

      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

end
