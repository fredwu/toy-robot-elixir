defmodule ToyRobotElixir.Utils do
  def rotate([ head | tail ]) do
    tail ++ [head]
  end
end
