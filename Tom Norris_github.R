rm(list=ls())
  library(sitar)
  library(tidyverse)
  library(readxl)
  library(glue)
  # library(DescTools) # AUC

  load('Tom Norris Rdata')

  save.image('Tom Norris Rdata')

setwd("C:\\Users\\pstn4\\OneDrive - Loughborough University\\LBORO WORK\\MHO work\\Data\\1946 biomedical\\time_severity_obese\\v2")
setwd("C:\\Users\\pstn4\\OneDrive - Loughborough University\\LBORO WORK\\MHO work\\Data\\1958 biomedical\\time_severity_obese\\v2")
setwd("C:\\Users\\pstn4\\OneDrive - Loughborough University\\LBORO WORK\\MHO work\\Data\\1970 biomedical\\time_severity_obese\\v2")

# read IOTF LMS -----------------------------------------------------------

  sexes <- c('male', 'female')
  iotf <- 'C:\\Users\\pstn4\\OneDrive - Loughborough University\\LBORO WORK\\MHO work\\Data\\1946 biomedical\\time_severity_obese\\v1\\Copy of IOTF_LMS.xls'
  iotf <- read_excel(iotf, range='A4:G37')
  names(iotf) <- c('age', paste0('v', 1:6))
  iotf <- rbind(iotf, tail(iotf, 1))
  upper_age <- 55 # add row for upper age limit
  iotf$age[nrow(iotf)] <- upper_age
  male <- iotf %>%
    select(age, v1:v3) %>%
    mutate(sex = 1) %>%
    rename(L.bmi=v1, M.bmi=v2, S.bmi=v3)
  female <- iotf %>%
    select(age, v4:v6) %>%
    mutate(sex = 2) %>%
    rename(L.bmi=v4, M.bmi=v5, S.bmi=v6)
  iotf <- bind_rows(male, female)
  levels(iotf$sex) <- sexes
  rm(male, female)

# iotf z-score cut-offs for overweight/obesity (rows) by sex (cols)
  iotf_co <- matrix(c(1.310, 2.288, 1.244, 2.192), nrow=2,
                    dimnames=list(c('overweight', 'obesity'), sexes))
#             male female
# overweight 1.310  1.244
# obesity    2.288  2.192

  iotf25 <- lapply(1:2, function (i) {
    iotfL <- with(iotf[iotf$sex == i,], approxfun(age, L.bmi))
    iotfM <- with(iotf[iotf$sex == i,], approxfun(age, M.bmi))
    iotfS <- with(iotf[iotf$sex == i,], approxfun(age, S.bmi))
    with(iotf[iotf$sex == i,],
      approxfun(age, iotfM(age) * (1 + iotfL(age) * iotfS(age) * iotf_co[1,i]) ^ (1/iotfL(age))))
  })
  iotf30 <- lapply(1:2, function (i) {
    iotfL <- with(iotf[iotf$sex == i,], approxfun(age, L.bmi))
    iotfM <- with(iotf[iotf$sex == i,], approxfun(age, M.bmi))
    iotfS <- with(iotf[iotf$sex == i,], approxfun(age, S.bmi))
    with(iotf[iotf$sex == i,],
      approxfun(age, iotfM(age) * (1 + iotfL(age) * iotfS(age) * iotf_co[2,i]) ^ (1/iotfL(age))))
  })
  names(iotf25) <- names(iotf30) <- sexes

  # read Tom Norris data (CHOOSE WHICH SEX/COHORT SEPECIFIC FILE)----------------------------------------------------

 # tn <- read_csv('NSHD_fitted values 10_40_males.csv')
 # tn <- read_csv('NSHD_fitted values 10_40_females.csv')
 # tn <- read_csv('NCDS_fitted values 10_40_males.csv')
 # tn <- read_csv('NCDS_fitted values 10_40_females.csv')
 # tn <- read_csv('BCS_fitted values 10_40_males.csv')
 # tn <- read_csv('BCS_fitted values 10_40_females.csv')
 # tn <- read_csv('~/Dropbox/Tom Norris/NSHD_fitted values 11_53_males_subsample.csv')
  
  names(tn) <- c('id', 'age', 'sex', 'bmi')
  tn$age18 <- with(tn, ifelse(age > 18, 18, age))
  tn$sex <- as.integer(factor(tn$sex, levels=sexes)) # sex levels 1 and 2
  iotf$years <- iotf$age
  tn$bmiz <- with(tn, LMS2z(age18, bmi, sex, 'bmi', 'iotf'))
  summary(tn)
  summary(factor(tn$id))

  source('C:\\Users\\pstn4\\OneDrive - Loughborough University\\LBORO WORK\\MHO work\\Data\\1946 biomedical\\time_severity_obese\\v1\\Tom Norris functions.R')

# plot BMI and BMIz by subject
  ggplot(tn, aes(age, bmi, group=factor(id), colour=factor(id))) +
    geom_line(show.legend=FALSE)
  ggplot(tn, aes(age, bmiz, group=factor(id), colour=factor(id))) +
    geom_line(show.legend=FALSE)

# Traits of interest
#
# Age of first obesity onset
# Duration of time spent obese
# Total obesity exposure (i.e. area under curve, but above cut-offs)
#
# Applied to obesity and overweight cut-offs separately

  tblist <- lapply(levels(factor(tn$id)), function(z) {
# returns crossing point(s) as age = x, bmiz = y
    td <- tn %>%
      filter(id == z) %>%
      select(age, bmi, bmiz, sex)
    isex <- unique(td$sex)
    tb <- lapply(1:2, function(i) # overweight cutoff then obesity cutoff
      curve_it(td, i, isex))
    tb <- do.call('rbind', tb) %>%
      mutate(id = z) %>%
      select(id, everything())
    if (nrow(tb)) {
      tb$auc25 <- round(AUC(td, iotf25[[isex]]), 4)
      tb$auc30 <- round(AUC(td, iotf30[[isex]]), 4)
    } else
      tb <- tibble(id=z, age=NA, bmiz=NA, up=NA, auc25=0, auc30=0)
    tb
  })
  tblist <- do.call('rbind', tblist)

  #change the filenmane depending on which sex and from which sample (e.g. nshd/ncds/bcs)
  #write.csv(tblist, 'obesity profiles_males_NSHD_v2.csv')
  #write.csv(tblist, 'obesity profiles_females_NSHD_v2.csv')
  #write.csv(tblist, 'obesity profiles_males_NCDS_v2.csv')
  #write.csv(tblist, 'obesity profiles_females_NCDS_v2.csv')
  #write.csv(tblist, 'obesity profiles_males_BCS_v2.csv')
  #write.csv(tblist, 'obesity profiles_females_BCS_v2.csv')
  
