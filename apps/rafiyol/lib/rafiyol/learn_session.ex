defmodule Rafiyol.LearnSession do
  alias Rafiyol.WordsQueue

  @table :learn_session

  def init do
    :ets.new(@table, [:set, :public, :named_table])
  end

  def create_session(user_id, words_list) do
    words = WordsQueue.new(words_list)
    :ets.insert(@table, {user_id, words})
  end

  def next_word(user_id) do
    case :ets.lookup(@table, user_id) do
      [] ->
        :no_session

      [{_, words}] ->
        {words, word} = WordsQueue.pop(words)

        case word do
          nil ->
            delete_session(user_id)
            :finish

          word ->
            :ets.insert(@table, {user_id, words})
            word
        end
    end
  end

  def again(user_id, word) do
    case :ets.lookup(@table, user_id) do
      [] ->
        :no_session

      [{_, words}] ->
        words = WordsQueue.insert(words, word)
        :ets.insert(@table, {user_id, words})
    end
  end

  def delete_session(user_id) do
    :ets.delete(@table, user_id)
  end
end
