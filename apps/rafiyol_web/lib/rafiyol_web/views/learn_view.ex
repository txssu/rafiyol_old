defmodule RafiyolWeb.LearnView do
  use RafiyolWeb, :view

  def start_session_button(conn, text) do
    button(text, to: Routes.learn_path(conn, :create), class: "btn btn-primary")
  end
end
