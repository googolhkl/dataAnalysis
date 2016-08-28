install.packages("rvest")
library(httr)
library(rvest)
library(stringr)

#  게시판 URL
list.url = 'http://kin.naver.com/search/list.nhn?cs=utf8&query=강릉맛집'

# 제목과 본문을 저장할 벡터
titles = c()
contents = c()

# 게시판 1~2페이지 크롤링
for(i in 1:100){
  url = modify_url(list.url, query=list(page=i))  # 게시판 URL에서 페이지를 변경
  h.list = read_html(url)  # 게시물 목록을 가져옴
  
  # 게시물 링크 추출
  title.links = html_nodes(h.list, '.basic1 dt a')
  article.links = html_attr(title.links, 'href')  
  
  for(link in article.links){
    h = read_html(link)  # 게시물을 가져옴
    
    # 제목
    title = html_text(html_nodes(h, '.end_question._end_wrap_box h3'))
    
    title = str_trim(repair_encoding(title))
    
    titles = c(titles, title)
    
    # 내용
    content = html_nodes(h, '.end_question .end_content._endContents')
    
    ## 모바일 질문 내용 
    no.content = html_text(html_nodes(content, '.end_ext2'))
    
    content = repair_encoding(html_text(content))
    
    ## 모바일 질문 내용 삭제
    ## 예) http://kin.naver.com/qna/detail.nhn?d1id=8&dirId=8&docId=235904020&qb=7Jes65Oc66aE&enc=utf8&section=kin&rank=19&search_sort=0&spq=1
    if (length(no.content) > 0)
    {
      content = str_replace(content, repair_encoding(no.content), '')
    }
    
    content <- str_trim(content)
    
    contents = c(contents, content)
    
    print(link)
    
  }
}

# 결과 저장
#result = data.frame(titles, contents)
#result
sink("naver.txt")
contents
sink()
