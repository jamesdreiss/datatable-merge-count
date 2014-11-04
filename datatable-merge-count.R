library(data.table)
library(dplyr)

# Args:
# raw: a data.table with last names, emails, and addresses to be merged primary records
# emails: a list of idnumbers (unique) and emails; emails are not required to be unique, and in fact it's assumed different ids may share the same email address (i.e. spouses)
# adds: a list of idnumbers (unique) and addresses; addreses are not required to be unique, and it's assumed different ids share the same address

# Emails and addresses are cleaned prior to function calls (removing ".", "-", etc.)
# To create key combinations before function calls, street numbers are stripped from addresses (e.g. "100" in "100 Franklin Street") and zipcodes are processed to be a max of 5 characters
# allow.cartesian = TRUE does not need to be specified in merges since unique key values are taken for raw beforehand; this would otherwise be desirable since rows, specifically idnumbers, from duplicate key matches need to be preserved


EmailMatch <- function(raw, emails) {
  # Finds email matches
  
  setkey(raw, email)
  setkey(emails, email)
  
  raw <- unique(raw)
  emails <- unique(emails, by = c("idnumber", "email"))
  
  email.matches <- 
    merge(raw, emails) %>%
    .[, occurences := 1] %>%
    .[, email.match.count := sum(occurences), by = email] %>%
    .[,.(idnumber, email, email.match.count)]
      
  email.matches
}

EmailKeyMatch <- function(raw, emails) {
  # Finds email key matches (last name + email)
  
  setkey(raw, emailkey)
  setkey(emails, emailkey)
  
  raw <- unique(raw)
  emails <- unique(emails, by = c("idnumber", "emailkey"))
  
  emailkey.matches <- 
    merge(raw, emails) %>%
    .[, occurences := 1] %>%
    .[, emailkey.match.count := sum(occurences), by = emailkey] %>%
    .[,.(idnumber, emailkey, emailkey.match.count)]
    
  emailkey.matches
}

AddKeyMatch <- function(raw, adds) {
  # Finds addkey matches (last name + first numbers on street address + zip)
  
  setkey(raw, addkey)
  setkey(adds, addkey)
  
  raw <- unique(raw)
  adds <- unique(adds, by = c("idnumber", "addkey"))
  
  addkey.matches <- 
    merge(raw, adds) %>%
    .[, occurences := 1] %>%
    .[, addkey.match.count := sum(occurences), by = addkey] %>%
    .[,.(idnumber, addkey, addkey.match.count)]
  
  addkey.matches
}