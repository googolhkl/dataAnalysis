import urllib.request

client_id = "네이버개발자센터에서발급"
client_secret = "네이버개발자센터에서발급"

# 검색을 원하는 단어
query = "강릉맛집"

# 검색 결과 출력 건수 지정(기본=10, 최대=100)
display = "100"

# 검색 시작 위치로 최대 1000까지 가능
start = "1"

# 정렬옵션 sim(유사도순), date(날짜순)
sort = "sim"

url = "https://openapi.naver.com/v1/search/blog.xml?query=" + query +"&display=" + display + "&start=" + start + "sort=" + sort

url = url.encode("utf-8")
url = str(url)
url = url.split('\'')
url = url[1].replace("\\", "%")
url = url.replace("%x", "%")
 
request = urllib.request.Request(url)
request.add_header("X-Naver-Client-Id",client_id)
request.add_header("X-Naver-Client-Secret",client_secret)
 
response = urllib.request.urlopen(request)
response_body = response.read().decode("utf-8")

filename = "naverBlog" + "_" + query + ".xml"
out = open(filename, "w")
print(response_body, file=out)
out.close()
