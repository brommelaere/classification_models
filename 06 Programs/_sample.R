rm(list=ls()) # Removes all objects from the current workspace (R memory)
options(scipen=999) # Do not print with Scientific Notation

# Program Details: Overview -----------------------------------------------
# *************************************************************************
script.meta <- list(
  Programmer   = "Ben Rommelaere",
  Project			 = "",
  Program      = "",
  Version      = 1,
  Date_Created = "MM/DD/YYYY",
  Last_Updated = "MM/DD/YYYY",
  ############################
  Description  = 
    "Description of program",
  ############################
  Notes        = 
    "Program notes"
)
# packages ----------------------------------------------------------------
library(rvest)
library(tidyverse)

# Paths -------------------------------------------------------------------
main <- "~/Project-Folder"
untouched <- file.path(main, "01 Untouched")
raw <- file.path(main, "02 Raw")
base <- file.path(main, "03 Base")
temp <- file.path(main, "04 Intermediate")
output <- file.path(main, "05 Output")
# *************************************************************************

# ----------------------------------------------------------
# 1: Main Section Header
# ----------------------------------------------------------

# 1.a: Sub-Section Header ----------------------------------
