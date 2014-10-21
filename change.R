## Changing HTTP to HTTPS
library(httr)
library(rjson)
library(RCurl)

# Function to assemble list of urls
changeUrl <- function(apiKey, from = "http:", to = "https:") {
  cat("Assembling list ...\n")
  urlList = 'https://data.hdx.rwlabs.org/api/action/related_list'
  relatedList <- fromJSON(getURL(urlList))
  
  cat('---------------------------------\n')
  cat('Changing URLs.\n')
  cat('---------------------------------\n')
  for (i in 1:length(relatedList$result)) {
    targetId <- relatedList$result[[i]]$id
    safeUrl <- gsub(from, to, relatedList$result[[i]]$image_url)
    cat(i, "| ", "id: ", targetId, " | ", "safe url: ", safeUrl,  "\n")
    
    # Making post request
    pars <- list(
      id = targetId,
      image_url = safeUrl
    )
    
    POST("https://data.hdx.rwlabs.org/api/action/related_update", 
         body = pars,
         add_headers(Authorization = apiKey)
    )
  }  
}

changeUrl()
