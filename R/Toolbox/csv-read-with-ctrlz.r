# Straightforward: left file connection opened
df <- read.csv(text=readLines(file("bad-ctrlz.csv", "rb")))


# Elegant: close file when complete loading csv ... Recommended this way!
fr <- file("bad-ctrlz.csv", "rb")
df <- read.csv(text = readLines(fr))
close(fr)

