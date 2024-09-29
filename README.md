# 애플 날씨 앱 - Weather

iOS 사전 과제 - Weather

> 🧑🏻‍💻 과제 수행 기간: 24.09.24 ~ 23.09.29 (5일)

![1](https://github.com/user-attachments/assets/ba762a2c-6073-4790-b826-89d3071e3b5e)

<br>

# ⚙️ Framework / Architecture

- SwiftUI
- Combine
- MVI
- SPM

<img width="1028" alt="image" src="https://github.com/user-attachments/assets/932fa895-e0ee-4396-af52-0cce0dcc1bed">


## 🛠️ 개발 환경
- Xcode 15.4
- Swift 5.10
- iOS 16 버전


## 📂 프로젝트 폴더링 구조

- 앱의 베이스가 되는 `Core` 모듈을 로컬 패키지로 분리하여 관리하였습니다.
    > `DIContainer` / `ReducerProtocol`,`Store` / `NetworkRouter` 등..
- 외부 라이브러리를 사용하지 않았습니다.

| Weather | Core 모듈 |
| -------- | -------- |
| ![image](https://github.com/qwerty3345/ios-itunes-search/assets/59835351/c64f612b-7b15-42fc-b201-6bc9cefd3d49) | ![image](https://github.com/qwerty3345/ios-itunes-search/assets/59835351/7692e087-4dec-4655-a22a-bd5f90f06538) |

<br>

# 📱 동작 화면

|메인 화면|실시간 도시 검색|도시 날씨 조회|네트워크 모니터링|
|:---:|:---:|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/102637f7-da89-4df7-bd98-a6af9f901df7" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/c37453e3-4cf7-4cd6-ad56-33026125b8ff" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/4f2f7dbc-85f9-4b05-9193-f36f2ec29d95" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/60c89590-3d78-4b22-afc4-6fc169a2f897" width="200" height="390"/>|

<br>
<br>

# 🔍 개발 시 고려 사항

- **네트워크 모니터링**: 네트워크 단절 시 네트워크 단절 알림 UI 표시 및 재연결 시 데이터 업데이트
- **BaseURL, API 키 보안**: BaseURL과 API 키를 안전하게 관리하기 위해 `.gitignore` 로 커밋 예외 처리
- **`DateFormatter` Singleton 구현**: 생성 비용이 높은 `DateFormatter` 객체를 한 번만 인스턴화하여 비용 최소화
- **검색 시 빈 화면 처리**: 검색 결과가 없을 시 **결과 없음** 문구 표시(**`'검색 내용이 존재하지 않습니다'`**)
- **대소문자 구분 없는 검색**: 대소문자 구분 없이 검색이 가능도록 처리
- **Query String 파라미터 설정으로 `Overfetching` 방지**: Query String 파라미터 중 `exclude=minutely,alerts` 설정으로 불필요한 `minutely`와 `alerts` 데이터 호출 제외
- **부드러운 화면 전환을 위한 애니메이션 적용**: 애니메이션을 통한 부드러운 화면 전환으로 사용성 향상

<br>
