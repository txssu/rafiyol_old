defmodule Rafiyol.WordsQueue do
  defstruct next_id: 1, words: %{}, next_pop: 1

  def new do
    %Rafiyol.WordsQueue{}
  end

  def new(words) do
    Enum.reduce(words, %Rafiyol.WordsQueue{}, fn elem, acc ->
      insert(acc, elem)
    end)
  end

  def insert(%Rafiyol.WordsQueue{} = dict, word) do
    words = Map.put(dict.words, dict.next_id, word)

    dict
    |> Map.put(:words, words)
    |> increment_counter(:next_id)
  end

  def pop(%Rafiyol.WordsQueue{} = dict) do
    case Map.fetch(dict.words, dict.next_pop) do
      :error ->
        {dict, nil}

      {:ok, word} ->
        words = Map.delete(dict.words, dict.next_pop)

        dict =
          dict
          |> Map.put(:words, words)
          |> increment_counter(:next_pop)

        {dict, word}
    end
  end

  defp increment_counter(map, counter) do
    Map.update!(map, counter, &(&1 + 1))
  end
end
