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
- 라이트 모드 / Portrait Orientation 지원

## 📂 프로젝트 폴더링 구조

- 앱의 베이스가 되는 `Core` 모듈을 로컬 패키지로 분리하여 관리하였습니다.
    > `DIContainer` / `ReducerProtocol`,`Store` / `NetworkRouter` 등..
- 외부 라이브러리를 사용하지 않았습니다.

| Weather | Core 모듈 |
| -------- | -------- |
|<img src="https://github.com/user-attachments/assets/37bde20a-7bc1-4dee-805b-dce79bba21dc" width="240" height="500"/>|<img src="https://github.com/user-attachments/assets/88aa96f1-c4f5-4726-be68-b4d61fc13f16" width="240" height="400"/>|

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

![image](https://github.com/user-attachments/assets/bd5af92e-3574-4225-8d50-22243a4bb8fa)

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

![image](https://github.com/user-attachments/assets/f5d46daa-7b0d-4cf9-b03b-1655d6fef064)

<br>

# 📗 회고

이번 사전 과제를 진행하며 **DI 도입, SPM 적용** 등 몇 가지 새로운 도전들을 시도하였습니다. 그중 가장 큰 도전은 라이브러리의 도움없이 프로젝트를 A부터 Z까지 진행해보는 것이었습니다. 아키텍처 구조부터 네트워크 구성까지 직접 구현하였는데, 정말 쉽지 않은 여정이었던 것 같습니다. 하지만 그만큼 뿌듯했고, 성취감도 있는 프로젝트였습니다. 하지만 역시 아쉬운 지점들이 있었습니다.

**아쉬운 점 1) 테스트 코드 미작성**

이번 사전 과제 기간동안 스스로의 도전 목표 중 하나가 바로 테스트 코드 작성이었습니다. 좀 더 안정성 있는 앱 구현을 위해 테스트 코드를 작성하려고 하였지만 A부터 Z까지 라이브러리 없이 처음부터 구현하다보니 기간 내 작성하지 못하였습니다. 

**아쉬운 점 2) 아키텍처 성능**

이번에 구성한 아키텍처는 `MVI` 아키텍처이며, **`TCA`의 구조를 많이 참고**하여 구현하였습니다. 하지만 가장 최근 진행했었던 프로젝트 아키텍처(**`Redux`**)에서도 두드러졌던 문제가 여기서도 동일하게 나타났습니다. 그건 바로 **`Store`의 상태값 중앙화 관리로 인해 랜더링이 빈도수가 높아져 CPU 사용률이 기하급수적으로 높아진다**는 문제였습니다. 특히 이 문제는 사용자에게 TextField로 문자열을 입력받을 때 두드러졌습니다. 이 문제를 해결하기 위해 `Throttle`과 `Debounce`를 활용해보았지만 의미있는 성능 개선을 이루진 못했습니다.

<br>

**생각해본 해결방안**

이번 사전 과제 프로젝트를 진행하며 아쉬웠던 부분들을 해결하기 위해 스스로 해결법을 몇가지 생각해보았습니다.

**1) 목표에 집중할 것**

첫번째 아쉬운 지점인 **테스트 코드 미작성**에 대한 해결법입니다. 정해진 기한 안에 목표를 달성하기 위해선 도전에 대한 욕구를 조금 줄이고, 목표 지점 도달에 더 집중해야 한다고 생각했습니다. 개발은 결국 정해진 일정 안에 문제를 신속해야하는 것이기 때문에 저의 개발에 대한 도전적인 성향을 줄이고, 좀 더 목표 달성 지향적으로 바뀌어야 한다고 생각했습니다.

**2) Store 세분화**

개인적인 의견으로 두번째 아쉬운 지점인 **아키텍처 성능**에 관한 해결법입니다. 위에서 언급했듯 `Store`의 상태값 중앙화 관리로 인해 상태값이 하나만 바뀌어도 그 영향이 전체 성능에 영향을 미치는 문제가 발생하였습니다. 이는 한 `Store`에서만 상태값을 관리해주기 때문에 발생하는 문제라고 생각합니다. 이를 해결하기 `Store`를 좀 더 세분화하여 분산 관리하면 성능이 좀 더 개선될 거라고 생각했습니다. 

이번 사전 과제 프로젝트에서 경험한 문제들을 바탕으로, 더 나은 아키텍처를 설계하고 유지보수하기 쉬운 코드를 작성할 수 있도록 노력해봐야겠다 생각했습니다.
