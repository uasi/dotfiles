import_file("~/.iex.exs")

Mix.install([
  {:explorer, "~> 0.5"}
])

require Explorer.DataFrame

alias Explorer.DataFrame, as: DF
alias Explorer.Datasets
alias Explorer.Series, as: S

defmodule :_iexp do
  defmacro __using__(_opts) do
    quote do
      :_iexp.parse_argv!()
      |> :_iexp.set_df_variables()
    end
  end

  defmacro set_df_variables(dfs) do
    quote do
      var!(dfs) = unquote(dfs)

      [var!(df) = var!(df1), var!(df2), var!(df3), var!(df4), var!(df5), var!(df6) | _] =
        var!(dfs) ++ [nil, nil, nil, nil, nil, nil]
    end
  end

  def parse_argv! do
    {opts, argv} =
      System.argv()
      |> OptionParser.parse!(
        strict: [normalize_column_names: :boolean],
        aliases: [n: :normalize_column_names]
      )

    normalize = opts[:normalize_column_names]

    argv
    |> Enum.map(&read_data_frame!/1)
    |> then(&if(normalize, do: normalize_column_names(&1), else: &1))
  end

  def normalize_column_names(dfs) do
    dfs
    |> Enum.map(fn df ->
      df
      |> DF.rename_with(fn col ->
        col
        |> String.downcase()
        |> then(&Regex.replace(~r/[^0-9A-Za-z]+/, &1, "_"))
      end)
    end)
  end

  defp read_data_frame!(path) do
    ext = Path.extname(path)

    case ext do
      ".csv" -> DF.from_csv!(path)
      ".ipc" -> DF.from_ipc!(path)
      ".arrow" -> DF.from_ipc!(path)
      ".parquet" -> DF.from_parquet!(path)
      ".pqt" -> DF.from_parquet!(path)
      ".ndjson" -> DF.from_ndjson(path)
      ".jsonl" -> DF.from_ndjson(path)
      ".json" -> DF.from_ndjson(path)
      _ -> raise "unsupported file extension '#{ext}'"
    end
  end
end

defmodule :_iexp_helpers do
  defmacro normalize_column_names!() do
    quote do
      var!(dfs)
      |> :_iexp.normalize_column_names()
      |> :_iexp.set_df_variables()

      :ok
    end
  end
end

use :_iexp

import :_iexp_helpers
