defmodule MyAOC do
  @moduledoc """
  Interact with Advent of Code puzzles from Elixir.

  The `LB_AOC_SESSION` environment variable must be set with a valid Advent of
  Code session token.
  """

  @enforce_keys [:year, :day]
  defstruct [:year, :day]
  alias __MODULE__, as: Client

  def client!(year, day) do
    %Client{
      year: year,
      day: day
    }
  end

  @doc """
  Fetch the puzzle input.
  """
  def input!(%Client{year: year, day: day}) do
    Req.get!(
      ~s"https://adventofcode.com/#{year}/day/#{day}/input",
      headers: headers!()
    ).body
  end

  @doc """
  Fetch the puzzle prompt.
  """
  def prompt!(%Client{year: year, day: day}) do
    Req.get!(
      ~s"https://adventofcode.com/#{year}/day/#{day}",
      headers: headers!()
    ).body
    |> article!()
  end

  @doc """
  Submit the puzzle answer.
  """
  def answer!(%Client{year: year, day: day}, level, answer) do
    Req.post!(~s"https://adventofcode.com/#{year}/day/#{day}/answer",
      headers: headers!(),
      form: [level: level, answer: answer]
    ).body
    |> article!()
  end

  defp headers!() do
    session = System.fetch_env!("LB_AOC_SESSION")
    [{"Cookie", ~s"session=#{session}"}]
  end

  defp article!(body) do
    body
    |> Floki.parse_document!()
    |> Floki.find("article")
    |> Floki.raw_html()
  end
end
