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
| ![image](https://github.com/user-attachments/assets/37bde20a-7bc1-4dee-805b-dce79bba21dc) | ![image](https://github.com/user-attachments/assets/88aa96f1-c4f5-4726-be68-b4d61fc13f16) |

<br>

# 📱 동작 화면

|메인 화면|실시간 도시 검색|도시 날씨 조회|네트워크 모니터링|
|:---:|:---:|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/102637f7-da89-4df7-bd98-a6af9f901df7" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/c37453e3-4cf7-4cd6-ad56-33026125b8ff" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/4f2f7dbc-85f9-4b05-9193-f36f2ec29d95" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/60c89590-3d78-4b22-afc4-6fc169a2f897" width="200" height="390"/>|

<br>
<br>

# 🔍 개발 고려 사항

- **네트워크 모니터링**: 네트워크 단절 시 네트워크 단절 알림 UI 표시 및 재연결 시 데이터 업데이트
- **BaseURL, API 키 보안**: BaseURL과 API 키를 안전하게 관리하기 위해 `.gitignore` 로 커밋 예외 처리
- **`DateFormatter` Singleton 구현**: 생성 비용이 높은 `DateFormatter` 객체를 한 번만 인스턴화하여 비용 최소화
- **검색 시 빈 화면 처리**: 검색 결과가 없을 시 **결과 없음** 문구 표시(**`'검색 내용이 존재하지 않습니다'`**)
- **대소문자 구분 없는 검색**: 대소문자 구분 없이 검색이 가능도록 처리
- **Query String 파라미터 설정으로 `Overfetching` 방지**: Query String 파라미터 중 `exclude=minutely,alerts` 설정으로 불필요한 `minutely`와 `alerts` 데이터 호출 제외
- **부드러운 화면 전환을 위한 애니메이션 적용**: 애니메이션을 통한 부드러운 화면 전환으로 사용성 향상
- **Launch Screen 구현**: 앱 로딩 시간동안 사용자 경험 개선을 위해 구현
- **Activity Indicator 구현**: 사용자에게 백그라운드 작업이 진행 중임을 알리기 위해 구현 

<br>

# 🔥 개발 주요 내용

### 👉 코드 간소화를 위한 Property Wrapper를 활용한 의존성 주입

**도입 배경**

-  기존 `생성자 의존성 주입 방식`으로는 구현마다 일일히 객체를 생성해 코드가 복잡해져 가독성이 떨어지는 문제가 있었습니다. 이를 개선하고자 Property Wrapper를 도입하였습니다.

![image](https://github.com/user-attachments/assets/689594a4-922a-4c4a-b8fa-d1de2deae243)

<br>


**도입 결과**

 - `Propert Wrapper` 활용한 의존성 주입으로 아래 이미지와 같이 코드가 이전보다 더 간소화 되었으며, `Dependency Injection Container` 구현으로 의존성 주입 관리를 보다 일관되게 유지할 수 있었습니다.

<details>
  <summary><b>Property Wrapper 의존성 주입 코드</b></summary>
  <div markdown="1">
    ```swift
    @propertyWrapper
    struct Inject<T> {
        public let wrappedValue: T
        
        public init() {
            self.wrappedValue = DIContainer.shared.resolve(type: T.self)
        }
    }
    ```
 </div>
  </details>

<details>
  <summary><b>의존성 주입 컨테이너 코드</b></summary>
  <div markdown="1">
    final class DIContainer {
        
        private var storage: [String: Any] = [:]
        
        public static let shared = DIContainer()
        private init() {}
        
        public func register<T>(_ object: T, type: T.Type) {
            storage["\(type)"] = object
        }
        
        public func resolve<T>(type: T.Type) -> T {
            guard let object = storage["\(type)"] as? T else {
                fatalError("\(type)에 해당하는 객체가 등록되지 않았습니다.")
            }
            
            return object
        }
    }
 </div>
  </details>

<br>

![image](https://github.com/user-attachments/assets/d50e8d6e-9ee3-4c31-a856-73e3e882f0c8)

<br>

### 👉 Type Eraser Wrapper를 통한 제너릭 프로토콜 타입 추론 해결

**도입 배경**

- Swift 5.6부터 도입된 **프로토콜을 타입으로 사용할 땐 실존 타입(Existential Type)으로 사용해야 한다**는 규칙으로 인해 **Associatedtype으로 정의된 ReducerProtocol**(**`제너릭 프로토콜`**)을 타입으로 사용 시 `any` 키워드를 활용해 실존 타입으로 변환해야 한다는 오류가 발생하였습니다.

- 하지만 제너릭 프로토콜인 ReducerProtocol은 `any` 타입을 선언한들 런타입에 실존 타입으로 바로 사용될 수 없다는 문제가 있었습니다.

<details>
  <summary><b>ReducerProtocol 코드</b></summary>
  <div markdown="1">
    ```swift
    protocol ReducerProtocol {
        associatedtype State
        associatedtype Action
        
        typealias Effect = EffectType<Action>
        
        func reduce(state: inout State, action: Action) -> Effect
    }
    ```
 </div>
</details>

<br>

![image](https://github.com/user-attachments/assets/246c4100-ed55-45ab-86b0-7f7fe26c4e86)

<br>

**도입 결과**

- `Type Eraser Wrapper`인 `AnyReducer`를 정의해 **ReducerProtocol을 감싸는 형태로 타입을 제거**하여 구체적인 ReducerProtocol 구현을 감추고, 다양한 ReducerProtocol을 단일된 타입으로 처리할 수 있게 하였습니다. 이를 통해 ReducerProtocol을 실존 타입처럼 사욜할 수 있게 되었습니다.

<details>
  <summary><b>ReducerProtocol 코드</b></summary>
  <div markdown="1">
    ```swift
    struct AnyReducer<State, Action>: ReducerProtocol {
        
        private let _reduce: (inout State, Action) -> Effect
        
        init<R: ReducerProtocol>(
            _ reducer: R
        ) where R.State == State, R.Action == Action {
            self._reduce = reducer.reduce
        }
        
        func reduce(state: inout State, action: Action) -> EffectType<Action> {
            return _reduce(&state, action)
        }
    }
    ```
 </div>
</details>

<br>

![image](https://github.com/user-attachments/assets/6aca081b-e72a-4b0d-8ff7-7957af4b7200)


