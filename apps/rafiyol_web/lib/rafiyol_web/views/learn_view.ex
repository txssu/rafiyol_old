defmodule RafiyolWeb.LearnView do
  use RafiyolWeb, :view

  def start_session_button(conn, text, can_create) do
    if can_create do
      button(text, to: Routes.learn_path(conn, :create), class: "btn btn-primary")
    else
      raw("You're good, you have no more words for repetition")
    end
  end
end
