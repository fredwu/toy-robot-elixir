defmodule ToyRobotElixirTest do
  use ExUnit.Case
  doctest ToyRobotElixir

  alias ToyRobotElixir.{Robot, Utils}

  setup do
    Robot.init

    :ok
  end

  describe "Utils" do
    test ".rotate" do
      assert Utils.rotate([1, 2, 3, 4, 5]) == [2, 3, 4, 5, 1]
    end
  end

  describe "Robot golden path" do
    test ".place and .report" do
      Robot.place(1, 1, :north)

      assert Robot.report == %{x: 1, y: 1, direction: :north}
    end

    test ".move north" do
      Robot.place(0, 0, :north)
      Robot.move

      assert Robot.report == %{x: 0, y: 1, direction: :north}
    end

    test ".move east" do
      Robot.place(0, 0, :east)
      Robot.move

      assert Robot.report == %{x: 1, y: 0, direction: :east}
    end

    test ".move south" do
      Robot.place(1, 1, :south)
      Robot.move

      assert Robot.report == %{x: 1, y: 0, direction: :south}
    end

    test ".move west" do
      Robot.place(1, 1, :west)
      Robot.move

      assert Robot.report == %{x: 0, y: 1, direction: :west}
    end

    test ".left" do
      Robot.place(0, 0, :north)
      Robot.left

      assert Robot.report == %{x: 0, y: 0, direction: :west}
    end

    test ".right" do
      Robot.place(0, 0, :north)
      Robot.right

      assert Robot.report == %{x: 0, y: 0, direction: :east}
    end

    test "example c)" do
      Robot.place(1, 2, :east)
      Robot.move
      Robot.move
      Robot.left
      Robot.move

      assert Robot.report == %{x: 3, y: 3, direction: :north}
    end
  end

  describe "Robot error paths" do
    test ".place not called before .move" do
      Robot.move

      assert Robot.report == "Please place the robot first."
    end

    test ".place not called before .left" do
      Robot.left

      assert Robot.report == "Please place the robot first."
    end

    test ".place not called before .right" do
      Robot.right

      assert Robot.report == "Please place the robot first."
    end

    test ".place with positive out of bound x" do
      Robot.place(10, 0, :north)

      assert Robot.report == "Placement x: 10 is invalid."
    end

    test ".place with negative out of bound x" do
      Robot.place(-1, 0, :north)

      assert Robot.report == "Placement x: -1 is invalid."
    end

    test ".place with positive out of bound y" do
      Robot.place(0, 10, :north)

      assert Robot.report == "Placement y: 10 is invalid."
    end

    test ".place with negative out of bound y" do
      Robot.place(0, -1, :north)

      assert Robot.report == "Placement y: -1 is invalid."
    end

    test ".place with positive out of bound x and y" do
      Robot.place(10, 10, :north)

      assert Robot.report == "Placement x: 10 is invalid."
    end

    test ".place with negative out of bound x and y" do
      Robot.place(-1, -1, :north)

      assert Robot.report == "Placement x: -1 is invalid."
    end

    test ".place with invalid x" do
      Robot.place(:cat, 0, :north)

      assert Robot.report == "Placement x: cat is invalid."
    end

    test ".place with invalid y" do
      Robot.place(0, :cat, :north)

      assert Robot.report == "Placement y: cat is invalid."
    end

    test ".place with invalid direction" do
      Robot.place(0, 0, :cat)

      assert Robot.report == "Placement direction: cat is invalid."
    end

    test ".move out of boundary 1)" do
      Robot.place(0, 4, :north)
      Robot.move
      Robot.move

      assert Robot.report == "Placement y: 6 is invalid."
    end

    test ".move out of boundary 2)" do
      Robot.place(0, 0, :west)
      Robot.move

      assert Robot.report == "Placement x: -1 is invalid."
    end

    test ".move with invalid direction" do
      Robot.place(0, 0, :cat)
      Robot.move

      assert Robot.report == "Placement direction: cat is invalid."
    end

    test ".left with invalid direction" do
      Robot.place(0, 0, :cat)
      Robot.left

      assert Robot.report == "Placement direction: cat is invalid."
    end

    test ".right with invalid direction" do
      Robot.place(0, 0, :cat)
      Robot.right

      assert Robot.report == "Placement direction: cat is invalid."
    end

    test ".place recovers from invalid x" do
      Robot.place(10, 0, :north)
      Robot.place(0, 0, :north)

      assert Robot.report == %{x: 0, y: 0, direction: :north}
    end

    test ".place recovers from invalid y" do
      Robot.place(0, 10, :north)
      Robot.place(0, 0, :north)

      assert Robot.report == %{x: 0, y: 0, direction: :north}
    end

    test ".place recovers from invalid direction" do
      Robot.place(0, 0, :cat)
      Robot.place(0, 0, :north)

      assert Robot.report == %{x: 0, y: 0, direction: :north}
    end

    test ".left recovers from invalid placement" do
      Robot.place(5, 0, :east)
      Robot.move
      Robot.left

      assert Robot.report == %{x: 5, y: 0, direction: :north}
    end

    test ".right recovers from invalid placement" do
      Robot.place(0, 5, :north)
      Robot.move
      Robot.right

      assert Robot.report == %{x: 0, y: 5, direction: :east}
    end
  end
end
