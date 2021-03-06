context("boxes")

check_api <- function() {
  skip_on_cran()

  code <- NA
  try(code <- httr::status_code(httr::GET(osem_endpoint())))
  if (is.na(code)) skip("API not available")
}

test_that("a list of all boxes can be retrieved and returns a sensebox data.frame", {
  check_api()

  boxes <- osem_boxes()
  expect_true(is.data.frame(boxes))
  expect_true(is.factor(boxes$model))
  expect_true(is.character(boxes$name))
  expect_length(names(boxes), 14)
  expect_true(any("sensebox" %in% class(boxes)))
})

test_that("both from and to are required when requesting boxes, error otherwise", {
  expect_error(osem_boxes(from = as.POSIXct("2017-01-01")), "must be used together")
  expect_error(osem_boxes(to   = as.POSIXct("2017-01-01")), "must be used together")
})

test_that("a list of boxes with exposure filter returns only the requested exposure", {
  check_api()

  boxes <- osem_boxes(exposure = "mobile")
  expect_true(all(boxes$exposure == "mobile"))
})

test_that("a list of boxes with model filter returns only the requested model", {
  check_api()

  boxes <- osem_boxes(model = "homeWifi")
  expect_true(all(boxes$model == "homeWifi"))
})

test_that("box query can combine exposure and model filter", {
  check_api()

  boxes <- osem_boxes(exposure = "mobile", model = "homeWifi")
  expect_true(all(boxes$model == "homeWifi"))
  expect_true(all(boxes$exposure == "mobile"))
})

test_that("a list of boxes with grouptype returns only boxes of that group", {
  check_api()

  boxes <- osem_boxes(grouptag = "codeformuenster")
  expect_true(all(boxes$grouptag == "codeformuenster"))
})

test_that("endpoint can be (mis)configured", {
  check_api()

  expect_error(osem_boxes(endpoint = "http://not.the.opensensemap.org"), "resolve host")
})

test_that("a response with no matches returns empty sensebox data.frame and a warning", {
  check_api()

  suppressWarnings(boxes <- osem_boxes(grouptag = "does_not_exist"))
  expect_true(is.data.frame(boxes))
  expect_true(any("sensebox" %in% class(boxes)))
})

test_that("a response with no matches gives a warning", {
  check_api()

  expect_warning(osem_boxes(grouptag = "does_not_exist"), "no senseBoxes found")
})

test_that("data.frame can be converted to sensebox data.frame", {
  df <- osem_as_sensebox(data.frame(c(1,2), c("a", "b")))
  expect_equal(class(df), c("sensebox", "data.frame"))
})

test_that("boxes can be converted to sf object", {
  check_api()

  boxes <- osem_boxes()
  boxes_sf <- sf::st_as_sf(boxes)

  expect_true(all(sf::st_is_simple(boxes_sf)))
  expect_true("sf" %in% class(boxes_sf))
})

test_that("boxes converted to sf object keep all attributes", {
  check_api()

  boxes <- osem_boxes()
  boxes_sf <- sf::st_as_sf(boxes)

  # coord columns get removed!
  cols <- names(boxes)[!names(boxes) %in% c('lon', 'lat')]
  expect_true(all(cols %in% names(boxes_sf)))

  expect_true("sensebox" %in% class(boxes_sf))
})

test_that("box retrieval does not give progress information in non-interactive mode", {
  check_api()

  if (!opensensmapr:::is_non_interactive()) skip("interactive session")

  out <- capture.output(b <- osem_boxes())
  expect_length(out, 0)
})

