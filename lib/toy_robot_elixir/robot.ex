defmodule ToyRobotElixir.Robot do
  alias ToyRobotElixir.{Grid, Robot.Placement, Utils}

  import ToyRobotElixir.Robot.PlacementValidator

  @grid %Grid{}

  def init do
    Agent.start_link(fn -> %Placement{} end, name: :placement)

    placement_error
  end

  def place(x, _, _)         when invalid_x?(x),                 do: placement_error(:x, x)
  def place(_, y, _)         when invalid_y?(y),                 do: placement_error(:y, y)
  def place(_, _, direction) when invalid_direction?(direction), do: placement_error(:direction, direction)
  def place(x, y, direction),                                    do: initial_placement(x: x, y: y, direction: direction)

  def move(direction \\ placement.direction)
  def move(:north), do: update_placement(y: placement.y + 1)
  def move(:east),  do: update_placement(x: placement.y + 1)
  def move(:south), do: update_placement(y: placement.y - 1)
  def move(:west),  do: update_placement(x: placement.y - 1)
  def move(_),      do: nil

  def left,  do: !placement.error && update_placement(direction: turn(placement.direction, :left))
  def right, do: !placement.error && update_placement(direction: turn(placement.direction, :right))

  def report, do: placement


  defp placement, do: Agent.get(:placement, &(&1))

  defp initial_placement(attrs) do
    for {key, value} <- attrs do
      Agent.update(:placement, &(%{&1 | :error => nil, key => value}))
    end
  end

  defp update_placement(x: x),                 do: place(x, placement.y, placement.direction)
  defp update_placement(y: y),                 do: place(placement.x, y, placement.direction)
  defp update_placement(direction: direction), do: place(placement.x, placement.y, direction)
  defp update_placement(error: error),         do: initial_placement(error: error)

  defp placement_error(key \\ nil, value \\ nil)
  defp placement_error(nil, _),     do: update_placement(error: "Please place the robot first.")
  defp placement_error(key, value), do: update_placement(error: "Placement #{key}: #{value} is invalid.")

  defp turn(direction, left_or_right) do
    directions(direction, left_or_right)
      |> Enum.drop_while(&(&1 != direction))
      |> tl
      |> hd
  end

  defp directions(:north, :left), do: @grid.directions |> Utils.rotate |> Enum.reverse
  defp directions(_,      :left), do: @grid.directions |> Enum.reverse
  defp directions(:east, :right), do: @grid.directions |> Utils.rotate
  defp directions(_,     :right), do: @grid.directions
end
