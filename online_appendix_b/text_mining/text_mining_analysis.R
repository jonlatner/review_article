# Top commands ----
# https://stackoverflow.com/questions/7505547/detach-all-packages-while-working-in-r
detachAllPackages <- function() {
  basic.packages <- c("package:stats","package:graphics","package:grDevices","package:utils","package:datasets","package:methods","package:base")
  package.list <- search()[ifelse(unlist(gregexpr("package:",search()))==1,TRUE,FALSE)]
  package.list <- setdiff(package.list,basic.packages)
  if (length(package.list)>0)  for (package in package.list) detach(package, character.only=TRUE)
  
}
detachAllPackages()

rm(list=ls(all=TRUE))

# FOLDERS - ADAPT THIS PATHWAY!!!
setwd("~/text_mining/")

# This is where you load all 43 articles in pdf form
input_files <- "literature/"

# LIBRARY
library(tidyverse)
library(tm)
library(RWeka)

# FUNCTIONS
# https://stackoverflow.com/questions/30994194/quotes-and-hyphens-not-removed-by-tm-package-functions-while-cleaning-corpus
# Remove everything that is not alphanumerical symbol or space:
removeSpecialChars <- function(x) gsub("[^a-zA-Z0-9 ]"," ",x)

# https://stackoverflow.com/questions/58142992/using-tm-to-mine-pdfs-for-two-and-three-word-phrases
# adjust to min = 1 and max = 2 for 2 word ngrams
RWeka_tokenizer <- function(x) {
  NGramTokenizer(x, Weka_control(min = 1, max = 2)) 
}

# https://data.library.virginia.edu/reading-pdf-files-into-r-for-text-mining/

# Create data ----
# load all 43 article pdfs into a single folder

# files <- list.files(pattern = "pdf$", path = input_files)

# Create corpus ----

# cr_corp <- Corpus(URISource(paste0(input_files,files)),
#                readerControl = list(reader = readPDF))

# saveRDS(cr_corp, paste0(input_files,"literature_review_corpus.rds"))

# Load corpus ----

cr_corp <- readRDS(paste0(input_files,"literature_review_corpus.rds"))

# Clean corpus ----

# Remove everything that is not alphanumerical symbol or space
cl_corp <- tm_map(cr_corp, content_transformer(removeSpecialChars))

# Analyze ----

my_words <- c(
  "bridge", 
  "institutional economics", 
  "job search", 
  "insider outsider", 
  "job matching", 
  "tournament", 
  "contract theory", 
  "asymmetry", 
  "information asymmetry", 
  "stepping stone","stepping stones", 
  "integration", 
  "dualization", 
  "trap", 
  "segmentation", 
  "human capital", 
  "rational choice", "rational", 
  "transaction cost", "transaction",
  "signalling",
  "screening")
# my_words <- c()
dtm <- DocumentTermMatrix(cl_corp, 
                          control=list(tokenize = RWeka_tokenizer,
                                                dictionary = my_words))
df1 <- data.frame(docs = dtm$dimnames$Docs, as.matrix(dtm), row.names = NULL, check.names = FALSE)
df1

# df1 is cleaned and formatted into excel file ~/text_mining/articles_theories.xlsx


