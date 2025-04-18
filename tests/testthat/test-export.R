testthat::test_that("Listing print correctly", {
  lsting <- as_listing(anl, key_cols = c("USUBJID"))
  main_title(lsting) <- "this is some title"
  main_footer(lsting) <- "this is some footer"
  testthat::expect_silent({
    export_as_txt(lsting, file = NULL)
  })
})

testthat::test_that("key columns repeat with export_as_txt", {
  skip_if_not_installed("dplyr")
  require("dplyr", quietly = TRUE)
  # pre-processing and ordering
  tmp_data <- ex_adae %>%
    dplyr::slice(1:30) %>%
    dplyr::distinct(USUBJID, AGE, BMRKR1, .keep_all = TRUE)

  lsting <- as_listing(tmp_data,
    key_cols = c("USUBJID", "AGE"),
    disp_cols = character()
  ) %>%
    add_listing_col("BMRKR1", format = "xx.x")

  listing_exp <- suppressMessages(export_as_txt(lsting, lpp = 4, verbose = TRUE, page_break = "\n"))

  testthat::expect_snapshot(cat(listing_exp))
})

testthat::test_that("key columns repeat with pagination with export_as_txt", {
  # pre-processing and ordering
  tbl <- as_listing(
    iris,
    key_cols = c("Species"),
    disp_cols = c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
  )

  listing <- export_as_txt(head(tbl),
    cpp = 50, paginate = TRUE,
    page_break = "\n"
  )

  testthat::expect_snapshot(cat(listing))
})

testthat::test_that("Listing print correctly, with paginate", {
  dat <- ex_adae
  lsting <- as_listing(dat[1:25, 1:8], key_cols = c("USUBJID", "AGE", "SEX"))
  page_out <- export_as_txt(lsting, file = NULL, paginate = TRUE, rep_cols = length(get_keycols(lsting)))

  expect_identical(length(gregexpr(c("Unique Subject Identifier"), page_out)[[1]]), 2L)
  expect_identical(length(gregexpr(c("Age"), page_out)[[1]]), 2L)
  expect_identical(length(gregexpr(c("Sex"), page_out)[[1]]), 2L)
})

testthat::test_that("export_as_txt works and repeats the correct lines in pagination", {
  dat <- ex_adae
  lsting <- as_listing(dat[1:25, c(seq(1, 3), 40)],
    key_cols = c("USUBJID", "AESOC"),
    main_title = "Example Title for Listing",
    subtitles = "This is the subtitle for this Adverse Events Table",
    main_footer = "Main footer for the listing",
    prov_footer = c(
      "You can even add a subfooter", "Second element is place on a new line",
      "Third string"
    )
  )
  # There are differences in pagination that should be taken into account (ref footnotes and rinfo)
  local_pagination <- paginate_listing(lsting, lpp = 33, cpp = 550, print_pages = FALSE)[[2]]
  testthat::expect_equal(
    matrix_form(local_pagination, TRUE, TRUE)$strings,
    paginate_to_mpfs(lsting, lpp = 33, cpp = 550)[[2]]$strings
  )

  pages_listings <- export_as_txt(lsting, file = NULL, paginate = TRUE, lpp = 33, cpp = 550)
  testthat::expect_snapshot(cat(pages_listings))
})

testthat::test_that("export_as_txt works with split_into_pages_by_var", {
  tmp_data <- ex_adae[1:50, ]

  lsting <- as_listing(
    tmp_data,
    key_cols = c("USUBJID", "AGE"),
    disp_cols = "SEX",
    main_title = "title",
    main_footer = "foot"
  ) %>%
    add_listing_col("BMRKR1", format = "xx.x") %>%
    split_into_pages_by_var("SEX", page_prefix = "Patient Subset - Sex")

  pages_listings <- export_as_txt(lsting, file = NULL, paginate = TRUE, lpp = 30, cpp = 65)
  testthat::expect_snapshot(cat(pages_listings))
})

testthat::test_that("export_as_txt works with empty listings", {
  df <- data.frame(
    x = with_label("Null Report: No observations met the reporting criteria for inclusion in this output.", "")
  )
  lsting <- as_listing(df)

  res <- export_as_txt(lsting)
  testthat::expect_snapshot(cat(res))
})

testthat::test_that("export_as_txt works with listings with all key cols", {
  lsting <- as_listing(
    df = ex_adcm[1:50, ],
    key_cols = c("BMRKR2", "CMCLAS", "CMDECOD"),
    disp_cols = c("BMRKR2", "CMCLAS", "CMDECOD"),
    unique_rows = TRUE
  )

  res <- export_as_txt(lsting)
  testthat::expect_snapshot(cat(res))
})
