library(magick) #Working with Images
library(stringr) #For Text Manipulation 

#Getting One Working Case ----
dog.image <- image_read("Exercise/dogs/dogs/dog.101.jpg") #grabbing a single file

dog.image.gray <- image_quantize(dog.image, colorspace = "gray")

image_write(dog.image.gray, path = "Exercise/Output/testdog.jpg", format = "jpg")


#Writing Function To Repeat ----
Read.Gray.Save <- function(file, outputfolder){
  
  
  dog.image <- image_read(file)
  dog.image.gray <- image_quantize(dog.image, colorspace = "gray")
  image_write(dog.image.gray, 
              path = file.path(outputfolder, str_c("grey.", basename(file))), #Adds the word grey to file name
              format = "jpg")
}

#Read.Gray.Save("Exercise/dogs/dogs/dog.101.jpg", "Exercise/Output") #Function Works

## Getting File iterations ----

dog.files <- dir("Exercise/dogs/dogs", full.names = T)


# Running in Series ----

ptm <- proc.time()
lapply(dog.files, Read.Gray.Save, outputfolder = "Exercise/Output/Output_Series/")

Series <- proc.time() - ptm

Series

#Running In Parallel ----
library(parallel)

ptm <- proc.time()

cl <- makeCluster(3)

clusterEvalQ(cl,{
  library(magick) #Working with Images
  library(stringr) #For Text Manipulation
})

parLapply(cl, dog.files, Read.Gray.Save, outputfolder = "Exercise/Output/Output_Parallel/")

stopCluster(cl)

Parallel <- proc.time() - ptm

Parallel

Series - Parallel #Time Saved?
