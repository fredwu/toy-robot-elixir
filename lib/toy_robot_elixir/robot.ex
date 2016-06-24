defmodule ToyRobotElixir.Robot do
  alias ToyRobotElixir.{ Robot.Placement, Utils }

  @directions [:north, :east, :south, :west]

  def place(x, y, direction) do
    placement = %Placement{ x: x, y: y, direction: direction }

    Agent.start_link(fn -> placement end, name: :placement)

    placement
  end

  def move(direction \\ report.direction)

  def move(:north), do: Agent.update(:placement, &(%{ &1 | y: &1.y + 1 }))
  def move(:east),  do: Agent.update(:placement, &(%{ &1 | x: &1.x + 1 }))
  def move(:south), do: Agent.update(:placement, &(%{ &1 | y: &1.y - 1 }))
  def move(:west),  do: Agent.update(:placement, &(%{ &1 | x: &1.x - 1 }))

  def left do
    Agent.update(:placement, &(%{ &1 | direction: turn_direction(&1.direction, :left) }))
  end

  def right do
    Agent.update(:placement, &(%{ &1 | direction: turn_direction(&1.direction, :right) }))
  end

  def report do
    Agent.get(:placement, &(&1))
  end

  defp turn_direction(direction, turn) do
    directions(direction, turn) |> new_direction(direction)
  end

  defp new_direction(directions, direction) do
    index = Enum.find_index(directions, &(&1 == direction))

    Enum.at(directions, index + 1)
  end

  defp directions(:north, :left), do: @directions |> Utils.rotate |> Enum.reverse
  defp directions(_,      :left), do: @directions |> Enum.reverse
  defp directions(:east, :right), do: @directions |> Utils.rotate
  defp directions(_,     :right), do: @directions
end
