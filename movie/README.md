# 데이터 정보 
##### 영화 정보는 [http://grouplens.org/datasets/movielens/](http://grouplens.org/datasets/movielens/)에서 다운로드할 수 있다. 
##### 영화 데이터는 아래의 명령어로 다운로드 한다.
```
$ wget http://files.grouplens.org/datasets/movielens/ml-latest.zip
```
##### 이 데이터는 34208개의 영화에서 22884377개의 `ratings`과 586994개의 `tag`가 있다. 자료 조사는 247753명을 대상으로 했고 기간은 1995.1.29 ~ 2016.1.29 까지 조사를 한 데이터다.

## User Ids
##### 이 필드는 `ratings.csv`와 `tags.csv`에 존재한다. 유저를 식별하기 위한 번호다.

## Movie Ids
##### 이 필드는 `ratings.csv`와 `tags.csv`, `movies.csv`, `links.csv`에 존재한다. 영화를 식별하기 위한 번호이고 하나의 영화는 하나의 `rating`과 `tag`를 반드시 포함해야 한다.
##### 영화의 정보를 보려면 <https://movielens.org/movie/무비번호> 를 이용하면 조회할 수 있다.
##### 예를 들어 토이스토리(movieId=1)는 [https://movielens.org/movie/1](https://movielens.org/movie/1)로 접속하면 조회 가능하다.

## ratings.csv
##### 이 파일은 다음과 같은 구조이다.
| userId | movieId | rating | timestamp |
| --- | --- | --- | --- |
##### rating은 별점을 말하고 범위는 0.5 ~ 5.0 이다.
##### Timestamp는 1970년 1월 이후로 부터 경과된 시간이다.

## tags.csv
##### 이 파일은 다음과 같은 구조이다.
| userId | movieId | tag | timestamp |
| --- | --- | --- | --- |
##### tag는 유저가 생성한 메타데이터다(영화를 하나의 단어로 표현한?). 예를 들면 리틀맨을 보고 `재밌는` 이라고 한 것이다.

## movies.csv
##### 이 파일은 다음과 같은 구조이다.
| movieId | title | genres |
##### title은 바로 알 수 있듯이 영화 제목이다.
##### genres는 영화의 장르이고 종류는 아래가 대표적이다.
* Action
* Adventure
* Animation
* Children's
* Comedy
* Crime
* Documentary
* Drama
* Fantasy
* Film-Noir
* Horror
* Musical
* Mystery
* Romance
* Sci-Fi
* Thriller
* War
* Western
* (no genres listed)

## links.csv
##### 이 파일은 다음과 같은 구조이다.
| movieId | imdbId | tmdbId |

##### imdbId는 `http://www.imdb.com` 사이트에서 제공하는 영화의 링크이다. 예를들어 토이스토리의 링크는 [http://www.imdb.com/title/tt0114709](http://www.imdb.com/title/tt0114709)에서 확인할 수 있다.
##### tmdbId는 `http://www.themoviedb.org` 사이트에서 제공하는 영화의 링크이다. 예를들어 토이스토리의 링크는 [http://www.themoviedb.org/movie/862](http://www.themoviedb.org/movie/862)에서 확인할 수 있다.

# 프로젝트 설명
## tag_rating
##### 이 맵리듀스는 ratings.csv와 tags.csv를 조인한 결과이다.
##### 조인결과 포맷은 다음과 같다.
| userID_movieID | userID | movieID | tag | timestamp | rating |
| --- | --- | --- | --- | --- | --- | --- |

##### 다음은 출력 데이터의 예다.
> 100028_2571     ,100028,2571,kung fu,1345178041,4.5

## movie_tag_rating
##### 이 맵리듀스는 ratings.csv와 tags.csv를 조인한 tag_rating.csv와 movies.csv를 조인한 결과이다.
##### 조인결과 포맷은 다음과 같다.
| movieId | userID_movieID | userID | movieID | tag | timestamp | rating | title | genres |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |

##### 다음은 출력 데이터의 예다.
> 1,75420_1,75420,1,adventure,1440326829,3.5,Toy Story (1995),Adventure|Animation|Children|Comedy|Fantasy
##### 영화 번호 1인 토이스토리 영화는 느낌을 `모험`으로 분류했고, 별점은 3.5개, 장르는  모험|애니메이션|어린이|코미디|판타지로 나눴다.

## popularTag
##### 이 맵리듀스는 별점 4.0 이상인 영화들의 장르의 숫자를 출력한다.
##### 그래서 어떠한 장르가 많은 사람들이 좋아하는지 알 수 있다.
##### 출력 파일의 포맷은 다음과 같다.
| genre | count |
| --- | --- |

##### 다음은 출력 데이터의 예다.
> American Civil War	18

##### 아메리칸 시빌 워가 18명의 사람들이 별점 4.0 이상을 주었다.
##### 참고로 속성간의 구분은 탭(\t)으로 한다.

## popularMovie2sequenceFile 
##### 이 작업은 `popularTag`의 결과 파일을 시퀀스 파일로 바꾸는 작업이다. 시퀀스 파일로 바꾸는 이유는 정렬을 하기 위해서이다.
##### 출력 파일의 포맷은 다음과 같다.
| count | genre | count |
| --- | --- | --- |

##### 다음은 출력 데이터의 예다.
> 18 American Civil War	18

##### popularTag의 결과에서 사람의 수를 키로 추가한 것 밖에 없다.

## movieSort
##### 이 작업은 사람의 수를 오름차순으로 정렬한 것이다.

## 완료
##### movieSort를 마치면 출력데이터를 아래 명령어로 로컬로 복사하자.
```
$ hdfs dfs -text movie_result/part-00000 > popularMovie.csv
```

##### popularMovie.csv 를 확인해 보면 어떤 것이 인기가 있는지 확인할 수 있다.

# 분석결과
[대중에게 사랑받는 영화](https://github.com/googolhkl/dataAnalysis/blob/master/movie/popularMovie.pdf)

