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
  def place(x, y, direction),                                    do: update_placement(x: x, y: y, direction: direction)

  def move(direction \\ placement.direction)
  def move(:north), do: placed? && update_placement(y: placement.y + 1)
  def move(:east),  do: placed? && update_placement(x: placement.y + 1)
  def move(:south), do: placed? && update_placement(y: placement.y - 1)
  def move(:west),  do: placed? && update_placement(x: placement.y - 1)
  def move(_),      do: placed?

  def left,  do: placed? && update_placement(direction: turn(placement.direction, :left))
  def right, do: placed? && update_placement(direction: turn(placement.direction, :right))

  def report, do: placement


  defp placed?(error \\ placement.error)
  defp placed?(nil), do: true
  defp placed?(_),   do: false

  defp placement, do: Agent.get(:placement, &(&1))

  defp update_placement(attrs) do
    for {key, value} <- attrs do
      Agent.update(:placement, &(%{&1 | :error => nil, key => value}))
    end
  end

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
