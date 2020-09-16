# find solutions where y = 0
curve_it <- function(curve1, i, isex) {
# Approximate the functional form of both curves
  curve1_f <- with(curve1, approxfun(age, bmiz, rule = 2))
  curve2 <- co2t(iotf_co[i, isex], range(curve1$age))
  curve2_f <- with(curve2, approxfun(age, bmiz, rule = 2))
  x <- seq(min(curve1$age), max(curve1$age), length=10001)
  ff <- with(data.frame(x=x), curve1_f(x) - curve2_f(x))
  soln <- which(infl(ff^2) & lag(sign(ff)) != lead(sign(ff)))
  ages <- x[soln]
  soln1 <- soln + 1 + 0/(soln < length(x))
  up <- ff[soln1] > 0
  tibble(age = ages,
         bmiz = c(25, 30)[i],
         up = up)
}

# test for inflections
infl <- function(y) c(FALSE, diff(diff(y) > 0) != 0, FALSE)

# test character is numeric
char_n <- function(x) tryCatch(as.numeric(x), warning=function(e) NA)

# create curve2 as cut-off
co2t <- function(co, xrange) tibble(age=xrange, bmiz=co)

# AUC with DescTools
# curve1 is with(tn, x=age, y=bmi)
# curve2 is IOTF curve with IOTF 25 or IOTF 30 to age 18 and 25/30 to age 55
AUC <- function(curve1, curve2_f) {
# Approximate the functional form of both curves
  curve1_f <- with(curve1, approxfun(age, bmi, rule = 2))
  x <- seq(min(curve1$age), max(curve1$age), length=1001)
  ff <- with(data.frame(x=x), curve1_f(x) - curve2_f(x))
  xy <- data.frame(x=x, y=ff)
  xy <- xy[xy$y >= 0, ]
  if (nrow(xy) == 0)
    return(0)
# AUC trapezoid from DescTools
  area <- with(xy, sum((apply(cbind(y[-length(y)], y[-1]), 1, mean)) *
           (x[-1] - x[-length(x)])))
  area
}
