defmodule ToyRobotElixir.Robot.Placement do
  @grid %ToyRobotElixir.Grid{}

  defstruct x: nil, y: nil, direction: :nil, error: nil

  defmacro invalid_x?(x),                 do: quote do: unquote(x) < 0 or unquote(@grid.max_x) < unquote(x)
  defmacro invalid_y?(y),                 do: quote do: unquote(y) < 0 or unquote(@grid.max_y) < unquote(y)
  defmacro invalid_direction?(direction), do: quote do: unquote(direction) in unquote(@grid.directions) == false
end
