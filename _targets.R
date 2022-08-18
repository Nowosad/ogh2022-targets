# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
library(targets)
library(terra)
library(supercells)
library(regional)

# Set target options:
tar_option_set(
  packages = c("tibble"), # packages that your targets need to run
  format = "rds" # default storage format
  # Set other options as needed.
)

# tar_make_clustermq() configuration (okay to leave alone):
options(clustermq.scheduler = "multicore")

# tar_make_future() configuration (okay to leave alone):
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# source("other_functions.R") # Source other scripts as needed. # nolint

# Replace the target list below with your own:
list(
  tar_target(
    name = input_raster,
    command = rast(system.file("ex/logo.tif", package = "terra"))
#   format = "feather" # efficient storage of large data frames # nolint
  ),
  tar_target(
    name = lab_raster,
    command = rgb_to_lab(input_raster)
  ),
  tar_target(
    name = sc1,
    command = supercells(rast(lab_raster), 500, compactness = 50)
  ),
  tar_target(
    name = sc2,
    command = supercells(rast(lab_raster), 500, compactness = 5)
  ),
  tar_target(
    name = sc3,
    command = supercells(rast(lab_raster), 1000, compactness = 3)
  ),
  tar_target(
    name = quality_sc1,
    command = mean(reg_inhomogeneity(sc1, rast(lab_raster)))
  ),
  tar_target(
    name = quality_sc2,
    command = mean(reg_inhomogeneity(sc2, rast(lab_raster)))
  ),
  tar_target(
    name = quality_sc3,
    command = mean(reg_inhomogeneity(sc3, rast(lab_raster)))
  )
)
