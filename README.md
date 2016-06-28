# Toy Robot Elixir

The infamous Toy Robot code test done in Elixir. Please see [PROBLEM.md](PROBLEM.md) for more information.

The purpose of this is for me to learn and practice Elixir after reading [Programming Elixir](https://pragprog.com/downloads/1724546).

## Prerequisite

- Erlang (tested on 18.3)
- Elixir (tested on 1.3)

## How to Run

    iex -S mix

    # examples

    iex> place 0, 0, :north
    iex> move
    iex> left
    iex> move
    iex> report

## Run Tests and Coding Style Checks

    mix t

## Author

- Fred Wu <ifredwu@gmail.com>
- 2016-06-25
