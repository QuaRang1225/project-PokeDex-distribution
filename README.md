

<img src="https://github.com/user-attachments/assets/110734d0-2360-4e8e-99c8-ffacf0e9af2c" width="12.5%" height="25%">

# 포케덱스

<p align="leading">
<img src="https://github.com/user-attachments/assets/725ebbc0-740c-4ea2-a894-492a75339a74" width="16%" height="25%">
<img src="https://github.com/user-attachments/assets/a689ab09-9972-401a-81ba-d8af5d854a82" width="16%" height="25%">
<img src="https://github.com/user-attachments/assets/62c2a675-d5a3-4255-bfba-2976efe417b8" width="16%" height="25%">
<img src="https://github.com/user-attachments/assets/237d033b-9424-46a0-ba89-3e766dd66101" width="16%" height="25%"> 
<img src="https://github.com/user-attachments/assets/b4b83671-b980-4dce-a5d6-65b594bad1ef" width="16%" height="25%">
</p>

```
💡 저는 취미로 포켓몬 게임을 즐기는데, 포켓몬 수와 형태가 워낙 다양하여 정보를 확인하고
능력치를 계산하기 위해 여러 사이트와 위키를 검색해서 참고해야 했습니다. 이러한 불필요한
작업을 최소화하고 추가적으로 나만의 포켓몬 조합을 구성할 수 있는 도감 어플리케이션
프로젝트를 시작하게 되었습니다.
```

## 🔗 관련링크


- [‎App Store](https://apps.apple.com/kr/app/%EC%98%AC%ED%8F%AC%EC%9B%90/id6450005052)
- [블로그](https://quarang.tistory.com/category/%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8/%EC%98%AC%ED%8F%AC%EC%9B%90)


### 🤔 고민한 점

> 포켓몬의 정보는 어떻게 불러올까?

- 직접 통신기능을 구현하지 않고 pokeAPI에서 제공하는 iOS RESTful API를 사용하기로 결정

> 이유는

- 인터넷 통신은 이미 다른 프로젝트에서도 해본 경험이 있고, 외부 라이브러리를 사용해보는 것을 목적으로 두었기 떄문 

> 사용 패키지


[PokemonAPI](https://github.com/kinkofer/PokemonAPI)


- 통신 이벤트에 callback 지옥을 우려해 async/await로 이벤트를 처리
- 포켓몬 상세정보를 확인하는 뷰에서 도감에 필요한 정보를 request/response

> 어떤 종류의 데이터베이스를 사용하면 좋을까? noSQL? RDBMS?


- 데이터베이스를 처음 사용하는 프로젝트임으로 필요한 곳에 적절한 요소를 사용하기 위한 조사과정이 필요 

## ver.1
![스크린샷 2023-12-01 오후 5 01 57](https://github.com/QuaRang1225/PokeDex_Project/assets/31721255/99136367-9631-42be-9e45-a69ee9387d6c)


1. 앱 다운 후 첫 실행 시 포켓몬 정보(List Row에 필요한)를 가공하여 DB에 한번에 저장 
2. 데이터를 한번 저장한 뒤에는 데이터가 변경될 일이 거의 없고 포켓몬 찜기능을 고려하여 noSqlDB 사용이 더 효율적이라 판단
3. 그중에 개발자에게 직관적이며 Andorid 확장 가능성이 용이한 RealmDB를 사용하기로 결정

### 📱 기능 & 화면

![스크린샷 2023-12-04 오후 7 39 55](https://github.com/QuaRang1225/PokeDex_Project/assets/31721255/68ddb760-c41b-4007-853c-0ace68c642be)


- 첫 실행 시 포켓몬도감 리스트 정보를 담는 작업 중에 간단한 퀴즈게임 제공

![스크린샷 2023-12-04 오후 7 39 41](https://github.com/QuaRang1225/PokeDex_Project/assets/31721255/b6b8ab41-3aa1-4170-b3d8-b7c41d640be8)


- 포켓몬 도감 리스트 - 지역 별로 포켓몬 도감번호 분류
- 포켓몬 상세정보,포켓몬 공격력/내구력 계산
- 내 포켓몬 저장소
  
## ver.2

> ver.1 문제점

- 데이터는 사용자들에게 모두 동일하게 적용됨에도 기기별로 데이터를 모두 다운로드 해야함 
- 포켓몬 상세정보를 조회하는 화면에서 해당 API요청이 여러개 존재해(상세정보 들의 데이터를 조회하려면 여러개의 도메인 주소로 요청을 했어야 했기 때문) 김함 트래픽 낭비 문제가 있었음

> 해결법

- 이런 문제들을 해결하고자 새로운 로직을 사용하기로 함
- 기존 API의 데이터를 다른 DB에 ETL하는 작업은 동일하지만, 디바이스 로컬DB가 아닌 개인 서버 DB에 저장하여 요청 트래픽 감소와 사용자 편의를 동시에 해결하는 방법 선택

> 수정사항

- 데이터 모델링
![스크린샷 2024-08-03 오후 5 01 10](https://github.com/user-attachments/assets/93492c46-b077-44dd-b93b-9040014cfaf9)
- 위 그림 처럼 ETL할 데이터를 사전에 모델링 진행
- [서버](https://github.com/QuaRang1225/project-PokeDex-server)를 직접 개발하고 AWS 호스팅
- 서버에 미리 데이터를 저장하고 관리할 데이터 관리 매니저[앱](https://github.com/QuaRang1225/project-PokeDex-developer)을 개발
- 수정된 전체 로직
![스크린샷 2024-08-03 오후 5 17 37](https://github.com/user-attachments/assets/67ef5057-c1f9-492c-afb4-6cffb5f62dad)


   
## 🔧 앱스토어 리젝 해결
['프로젝트/올포원' 카테고리의 글 목록](https://quarang.tistory.com/category/%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8/%EC%98%AC%ED%8F%AC%EC%9B%90)

## 프로젝트를 진행 하며..

```
👶🏻 이번 프로젝트는 진심으로 제가 관심있어하는 취미를 다뤘습니다. 즐겁게 개발한 동시에 앱스토어에 리젝을 가장 많이 당한 프로젝트였는데,
  앱 설계를 제대로 하지 않은 상태로 무작정 시작하여 제대로 테스트도 안해보고 개발부터 했기 때문에 생긴 시행착오였다고 생각합니다. 
  하지만 무작정 부딪혔기 때문인지 자신만의 장단점을 파악할 수 있는 기회를 얻을 수 있었고 프로젝트 로드맵을 구축하기 수월했으며,
  다양한 문제를 마주하다보니 문제 해결능력 또한 키울 수 있었습니다.

처음으로 앱의 전체적인 구조와 디자인까지 모두 혼자 기획한 프로젝트였는데,  여러 앱들의 mock-up과 UI/UX를 참고하여 최대한 
사용자가 접근하기 쉬운 앱을 제작하려 노력했습니다. 다행히 주변 지인들에게 긍정적인 평가를 받았으며, 프로젝트를 확장시킬 방향성도 
설정할 수 있게 되었습니다.

```
