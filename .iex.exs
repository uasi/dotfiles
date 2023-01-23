defmodule :_iex_prelude do
  defdelegate exit(), to: System, as: :halt

  defdelegate cl(), to: IEx.Helpers, as: :clear

  defdelegate r(), to: IEx.Helpers, as: :recompile
end

import :_iex_prelude
