library(readr)
library(dplyr)
library(tidyr)
library(purrr)
library(stringr)

moveuse <- readLines("game/dat/moveuse.dat")

multiuse_start_idx <- grep('BEGIN "MultiUse"', moveuse)

if (length(multiuse_start_idx) != 1) {
  stop('Expected exactly one BEGIN "MultiUse" marker.')
}

moveuse_before <- moveuse[seq_len(multiuse_start_idx)]
moveuse_after <- moveuse[(multiuse_start_idx + 1):length(moveuse)]

skinning_data <- read_csv(
  "assets/csv/skinning.csv",
  show_col_types = FALSE
)

moveuse_skinning <- skinning_data |>
  mutate(
    line_1 = str_glue(
      'MultiUse, IsType (Obj1, {tool_id}), IsType (Obj2, {corpse_id}), ',
      'Random ({percent_chance}) -> ',
      'Create(User, {reward_id}, 1), ',
      'IncrementSkinningValue(User, {race_id}, 1), ',
      'Effect(Obj2, 15), Change(Obj2, {next_corpse_id}, 0)'
    ),
    line_2 = str_glue(
      'MultiUse, IsType (Obj1, {tool_id}), IsType (Obj2, {corpse_id}) -> ',
      'Effect(Obj2, 14), Change(Obj2, {next_corpse_id}, 0)'
    )
  ) |>
  select(line_1, line_2) |>
  pivot_longer(
    cols = everything(),
    values_to = "line"
  ) |>
  pull(line)

moveuse_final <- c(
  moveuse_before,
  moveuse_skinning,
  moveuse_after
)

#writeLines(moveuse_final, "game/dat/moveuse.dat")
