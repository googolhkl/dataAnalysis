# 이 파일은 트위터에서 크롤링을 하는 파일이다.
install.packages("base64enc")
install.packages(c("RCurl", "twitteR", "ROAuth"))
library(base64enc)
library(RCurl)
library(twitteR)
library(ROAuth)

reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"

#트위터에서 받은 네 개의 키값(문자열에 각자 트위터 API 키값을 적어준다.) 
consummerKey <- ""
consummerSecret <- ""
accessToken <- ""
accessTokenSecret <- ""

options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

#인증 처리
setup_twitter_oauth(consummerKey, consummerSecret, accessToken, accessTokenSecret)

#계정이 남긴 글을 가져올 때
#user.tweets <- searchTwitter("@googolhkl", n=1000) # googolhkl계정이 남긴 글 1000개 가져오기
#save(user.tweets, file="/Users/googolhkl/tweets.RData") #수집된 데이터를 RData형식으로 저장

#해당 단어를 언급한 글을 가져올때
keyword <- enc2utf8("강릉맛집") #키워드 지정
user.tweets2 <- searchTwitter(keyword, n= 10000)

# 파일로 저장하기
# sink는 출력되는 내용들을 전부 파일로 저장한다. 다시 sink()를 호출하면 화면에 출력된다.
sink("twitter.txt")
user.tweets2
sink()


