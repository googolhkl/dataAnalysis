install.packages("KoNLP")    
install.packages("wordcloud")
install.packages("RColorBrewer") 

library(KoNLP)
library(wordcloud)

f <- file("/Users/googolhkl/test/dataAnalysis/matzip/data/sortWordCount/naverJisikIn/naver_JisikIn_강릉데이트",encoding="UTF-8", blocking = F )
savingPath <- "/Users/googolhkl/naver_JisikIn_강릉데이트.png"

# 데이터 손질
txtLines <- readLines(f)
txtLines <- gsub("\"","",txtLines)
txtLines <- gsub("\n","",txtLines)
txtLines <- gsub("\\n","",txtLines)
txtLines <- gsub("\t"," ",txtLines)
txt.in <- textConnection(txtLines)
txt.data <- read.table(txt.in)
txt.data

# 출력 설정, 출력, 저장하기
pal <- brewer.pal(9, "Pastel1")
jpeg(savingPath)
wordcloud(txt.data[,1], txt.data[,2], scale = c(5,1), rot.per = 0.25, min.freq = 1, random.order = F, random.color = T, colors = pal,family="AppleGothic")
dev.off()

