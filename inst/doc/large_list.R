## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval = FALSE-------------------------------------------------------------
# library(rlistings)
# 
# iris2 <- do.call(rbind, rep(list(iris), 40))
# rlist <- as_listing(iris2, key_cols = "Species",
#                     disp_cols = c("Sepal.Length", "Sepal.Width", "Petal.Width", "Petal.Length"))
# 
# bench::mark(
#   a = paginate_to_mpfs(rlist[1:1000, ]),
#   b = paginate_to_mpfs(rlist[1:2000, ]),
#   c = paginate_to_mpfs(rlist[1:3000, ]),
#   d = paginate_to_mpfs(rlist[1:4000, ]),
#   e = paginate_to_mpfs(rlist[1:5000, ]),
#   f = paginate_to_mpfs(rlist[1:6000, ]),
#   check = FALSE,
#   max_iterations = 1
# )

## ----eval = FALSE-------------------------------------------------------------
# iris3 <- cbind(iris2, gp = rep(c(1, 2, 3, 4, 5, 6), 1000))
# rlist3 <- as_listing(iris3, key_cols = "Species",
#                      disp_cols = c("Sepal.Length", "Sepal.Width", "Petal.Width", "Petal.Length"))
# 
# start.time <- Sys.time()
# rlist3  %>% split(rlist3$gp) %>% lapply(., paginate_to_mpfs)
# end.time <- Sys.time()
# 
# time.taken <- end.time - start.time
# time.taken
# 
# # > Time difference of 36.06119 secs

## ----eval = FALSE-------------------------------------------------------------
# library(parallel)
# 
# start.time <- Sys.time()
# rlist3  %>% split(rlist3$gp) %>% mclapply(., paginate_to_mpfs)
# end.time <- Sys.time()
# 
# time.taken <- end.time - start.time
# time.taken
# 
# #> Time difference of 18.20406 secs

