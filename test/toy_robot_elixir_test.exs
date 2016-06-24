defmodule ToyRobotElixirTest do
  use ExUnit.Case
  doctest ToyRobotElixir

  alias ToyRobotElixir.{ Robot, Utils }

  describe "Utils" do
    test "#rotate" do
      assert Utils.rotate([1, 2, 3, 4, 5]) == [2, 3, 4, 5, 1]
    end
  end

  describe "Robot" do
    test "#place" do
      assert Robot.place(0, 0, :north) == %Robot.Placement{ x: 0, y: 0, direction: :north }
    end

    test "#report" do
      Robot.place(1, 1, :north)

      assert Robot.report == %Robot.Placement{ x: 1, y: 1, direction: :north }
    end

    test "#move north" do
      Robot.place(0, 0, :north)
      Robot.move

      assert Robot.report == %Robot.Placement{ x: 0, y: 1, direction: :north }
    end

    test "#move east" do
      Robot.place(0, 0, :east)
      Robot.move

      assert Robot.report == %Robot.Placement{ x: 1, y: 0, direction: :east }
    end

    test "#move south" do
      Robot.place(1, 1, :south)
      Robot.move

      assert Robot.report == %Robot.Placement{ x: 1, y: 0, direction: :south }
    end

    test "#move west" do
      Robot.place(1, 1, :west)
      Robot.move

      assert Robot.report == %Robot.Placement{ x: 0, y: 1, direction: :west }
    end

    test "#left" do
      Robot.place(0, 0, :north)
      Robot.left

      assert Robot.report == %Robot.Placement{ x: 0, y: 0, direction: :west }
    end

    test "#right" do
      Robot.place(0, 0, :north)
      Robot.right

      assert Robot.report == %Robot.Placement{ x: 0, y: 0, direction: :east }
    end

    test "example c)" do
      Robot.place(1, 2, :east)
      Robot.move
      Robot.move
      Robot.left
      Robot.move

      assert Robot.report == %Robot.Placement{ x: 3, y: 3, direction: :north }
    end
  end
end
