# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :branch_point, branch_points: %{
  map_lookup_vs_pattern_matching: [
    "map lookup",
    "pattern matching"
  ],
  inline_vs_no_inline: [
    "with inline",
    "without inline"
  ]
}
