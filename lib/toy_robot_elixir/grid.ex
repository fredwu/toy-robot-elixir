defmodule ToyRobotElixir.Grid do
  defstruct max_x: 5,
            max_y: 5,
            directions: [:north, :east, :south, :west]
end
