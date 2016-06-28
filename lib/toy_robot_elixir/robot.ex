defmodule ToyRobotElixir.Robot do
  alias ToyRobotElixir.{Grid, Robot.Placement, Utils}

  import ToyRobotElixir.Robot.PlacementValidator

  @directions %Grid{}.directions

  def init do
    Agent.start_link(fn -> %Placement{} end, name: :placement)

    placement_error
  end

  def place(x, _, _)         when invalid_x?(x),                 do: placement_error(:x, x)
  def place(_, y, _)         when invalid_y?(y),                 do: placement_error(:y, y)
  def place(_, _, direction) when invalid_direction?(direction), do: placement_error(:direction, direction)
  def place(x, y, direction),                                    do: update_placement(x: x, y: y, direction: direction)

  def move do
    case placement.direction do
      :north -> update_placement(y: placement.y + 1)
      :east  -> update_placement(x: placement.x + 1)
      :south -> update_placement(y: placement.y - 1)
      :west  -> update_placement(x: placement.x - 1)
      _      -> nil
    end
  end

  def left,  do: update_direction(:left)
  def right, do: update_direction(:right)

  def report do
    case placement do
      %Placement{error: nil} -> %{x: placement.x, y: placement.y, direction: placement.direction}
      _                      -> placement.error
    end
  end


  defp placement, do: Agent.get(:placement, &(&1))

  defp placement_error(key \\ nil, value \\ nil)
  defp placement_error(nil, _),     do: update_placement(error: "Please place the robot first.")
  defp placement_error(key, value), do: update_placement(error: "Placement #{key}: #{value} is invalid.")

  defp update_placement(x: x),                 do: place(x, placement.y, placement.direction)
  defp update_placement(y: y),                 do: place(placement.x, y, placement.direction)
  defp update_placement(direction: direction), do: place(placement.x, placement.y, direction)
  defp update_placement(attrs) do
    for {key, value} <- attrs do
      Agent.update(:placement, &(%{&1 | :error => nil, key => value}))
    end
  end

  defp update_direction(left_or_right) do
    if placement.direction in @directions do
      update_placement(direction: turn(placement.direction, left_or_right))
    end
  end

  defp turn(direction, left_or_right) do
    directions(direction, left_or_right)
      |> Enum.drop_while(&(&1 != direction))
      |> tl
      |> hd
  end

  defp directions(:north, :left), do: @directions |> Utils.rotate |> Enum.reverse
  defp directions(_,      :left), do: @directions |> Enum.reverse
  defp directions(:east, :right), do: @directions |> Utils.rotate
  defp directions(_,     :right), do: @directions
end
