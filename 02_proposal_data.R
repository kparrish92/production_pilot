# Libraries 

library(here)
library(fs)
library(data.table)
library(dplyr)
library(tidyverse)
library(equivalence)
library(dplyr)
library(lme4)
library(lmerTest)
library(sjPlot)

# Import Spanish L1 data 
list_of_files <- list.files(path = "raw_data/se_wav_files/tables", recursive = TRUE,
                            pattern = "\\.Table$", 
                            
                            full.names = TRUE)
all_se <- rbindlist(sapply(list_of_files, fread, simplify = FALSE),
                    use.names = TRUE, idcol = "FileName") 

# Tidy data 
all_se = all_se %>% 
  mutate(vot = (tmax - tmin)*1000) %>% 
  separate(text, into = c("participant", "language", "word"), sep = "_") 

# GLMM for span_model
span_model = lmer(vot ~ language + (1 + language | participant), data = all_se)


# intercept for participant, slope for language 

summary(span_model)

tab_model(span_model)


# TOST Spanish 

# Put the data in wide format 
all_se_wide_e = all_se %>% 
  dplyr::select(language, participant, vot, word) %>% 
  filter(language == "english")

all_se_wide_s = all_se %>% 
  dplyr::select(language, participant, vot, word) %>% 
  filter(language == "spanish")

all_se_wide_f = all_se %>% 
  dplyr::select(language, participant, vot, word) %>% 
  filter(language == "french")

mean_french_sl1 = mean(all_se_wide_f$vot) %>% 
  round(digits = 2)

sd_french_sl1 = sd(all_se_wide_f$vot) %>% 
  round(digits = 2)

mean_spanish_sl1 = mean(all_se_wide_s$vot) %>% 
  round(., digits = 2)

sd_spanish_sl1 = sd(all_se_wide_s$vot) %>% 
  round(digits = 2)

mean_english_sl1 = mean(all_se_wide_e$vot) %>% 
  round(digits = 2)

sd_english_sl1 = sd(all_se_wide_e$vot) %>% 
  round(digits = 2)

### TOST for power analysis 

# English French 
TOSTER::TOSTtwo(m1 = mean_english_sl1, m2 = mean_french_sl1, 
       sd1 = sd_english_sl1, sd2 = sd_french_sl1, 
       n1 = 79, n2 = 80, 
       low_eqbound_d = -.5, 
       high_eqbound_d = .5, 
       alpha = 0.05,
       var.equal = FALSE)

