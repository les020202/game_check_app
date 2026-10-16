# 9. 로그인 전에는 로컬, 로그인 후에는 Firestore에 저장해야 하는 문제 (서비스 분리 + `ProxyProvider`)

[← README로 돌아가기](../README.md#트러블슈팅)

## 증상

앱의 요구사항이 다음과 같았음.

- 로그인 **전**: 기기 내부(로컬 DB)에 데이터 저장
- 로그인 **후**: 클라우드(Firestore)에 데이터 저장

`GameProvider` 안에서 `if (isLoggedIn) { Firestore... } else { Drift... }` 식으로 분기하면 저장/조회 코드마다 조건문이 반복되고, 로그인 상태가 바뀔 때 어느 저장소를 쓸지 관리하기 복잡해짐.

## 원인

`GameProvider`가 "데이터를 어디에 저장하는가"라는 세부 구현까지 직접 알고 있으면 역할이 섞임. 저장소가 늘어나거나 바뀔 때마다 `Provider` 코드를 함께 수정해야 하고, 로그인 상태 변화에 대응하는 로직도 흩어지게 됨.

## 해결 — 1단계: 서비스 계층 분리

공통 부모인 `game_service`를 만들고, 이를 상속받아 저장소별 구현체를 2개 만듦.

- `drift_game_service`: 로컬(Drift) DB 사용 (비로그인 상태)
- `firestore_game_service`: Firestore 사용 (로그인 상태)

두 서비스가 같은 인터페이스(부모 클래스)를 따르기 때문에, `GameProvider`는 어떤 서비스가 들어오든 **똑같은 방식으로 호출**만 하면 됨. 저장소가 무엇인지는 신경 쓰지 않아도 됨.

## 해결 — 2단계: 로그인 상태에 따라 서비스를 주입

`main`의 Provider 설정에서 `ChangeNotifierProxyProvider`를 사용해, `FirebaseAuthProvider`의 로그인 상태를 보고 알맞은 서비스를 `GameProvider`에 넣어줌.

```dart
ChangeNotifierProxyProvider<FirebaseAuthProvider, GameProvider>(
  create: (context) => GameProvider(
    context.read<FirebaseAuthProvider>().isLoggedIn
        ? FirestoreGameService()
        : DriftGameService(db),
  ),
  update: (_, auth, previous) {
    final usingFirestore = previous?.service is FirestoreGameService;
    if (previous != null && usingFirestore == auth.isLoggedIn) {
      return previous; // 로그인 상태가 그대로면 기존 인스턴스 유지
    }
    return GameProvider(
      auth.isLoggedIn ? FirestoreGameService() : DriftGameService(db),
    );
  },
),
```

| 부분 | 역할 |
| --- | --- |
| `ChangeNotifierProxyProvider<A, B>` | `A`(`FirebaseAuthProvider`)의 값이 바뀔 때마다 `B`(`GameProvider`)를 다시 만들거나 갱신할 수 있게 해주는 Provider. 다른 Provider에 의존하는 Provider를 만들 때 사용 |
| `create` | 앱 시작 시 `GameProvider`를 처음 만드는 부분. 현재 로그인 여부를 보고 `FirestoreGameService` 또는 `DriftGameService`를 선택해 주입 |
| `update` | `FirebaseAuthProvider`가 변경될 때마다 호출됨. 로그인 상태가 바뀌었는지 확인해서 서비스를 교체할지 결정 |
| `previous?.service is FirestoreGameService` | 기존 `GameProvider`가 현재 Firestore 서비스를 쓰고 있는지 확인 |
| `usingFirestore == auth.isLoggedIn` | 현재 쓰는 저장소와 로그인 상태가 일치하면(변화 없음) 기존 인스턴스를 그대로 반환 |
| `return GameProvider(...)` | 로그인 상태가 바뀐 경우에만 새 서비스를 주입한 새 `GameProvider`를 생성 |

## 핵심 포인트: 왜 기존 인스턴스를 유지하는가

`update`는 `FirebaseAuthProvider`가 `notifyListeners()`를 호출할 때마다 실행됨. 이때 매번 새 `GameProvider`를 만들면 화면에 올라가 있던 상태(불러온 게임 데이터 등)가 초기화되어버림. 그래서 "로그인 상태가 실제로 바뀐 경우에만" 새로 만들고, 그렇지 않으면 `previous`를 그대로 반환하도록 조건을 둔 것.

## 정리

- 저장소 선택 로직은 `main`의 Provider 설정 한 곳에만 있고, `GameProvider`와 화면 코드는 저장소를 몰라도 됨.
- 나중에 저장소를 하나 더 추가하고 싶다면 `game_service`를 상속하는 서비스를 새로 만들고 주입 조건만 추가하면 됨.
- 참고로 로그인 시 로컬 데이터를 Firestore로 옮길지는 위 방식만으로는 처리되지 않으므로, 별도의 마이그레이션 로직이 필요함. (이 앱에서는 로그인 시 "계정에 저장 / 버리기 / 로그인 취소"를 선택하는 다이얼로그로 처리)
