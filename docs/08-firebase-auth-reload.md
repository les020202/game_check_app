# 8. Firebase Auth 기능 구현 중 타이밍 이슈 (`reload()` 후 최신 유저 정보 반영)

[← README로 돌아가기](../README.md#트러블슈팅)

## 증상

회원가입 직후 자동으로 로그인된 상태에서 마이페이지에 이메일은 표시되는데 닉네임은 비어 있음. 로그아웃 후 다시 로그인하면 닉네임이 정상적으로 표시됨. (유저 정보를 변경한 직후 `Provider`가 들고 있는 `_user`나 화면에 예전 정보가 남는 문제 전반에 해당함.)

## 원인

- 회원가입은 "계정 생성 → 닉네임 설정(`updateDisplayName`) → 인증 메일 발송" 순서로 진행됨. 계정 생성 직후에는 이메일만 있고 `displayName`은 아직 `null`임.
- `currentUser`로 얻은 `User` 객체는 **로그인 시점 또는 마지막 갱신 시점의 스냅샷**이라, 서버에서 값이 바뀌어도 자동으로 반영되지 않음.
- 앱은 이 유저 정보를 `AppUser` 모델로 변환해 `_user`에 보관하는데(`displayName ?? ''`), 이미 변환해 둔 값은 이후에 바뀌지 않음. `reload()`는 기존 `User` 객체만 갱신하므로, 다시 읽어서 변환하지 않으면 `_user`는 예전 상태 그대로임.
- 갱신 후 `notifyListeners()`를 호출하지 않으면 UI도 다시 그려지지 않음.
- 서버에는 닉네임이 정상 저장되어 있었기 때문에, 재로그인하면 최신 값으로 `AppUser`가 새로 만들어져 정상 표시됨.

## 해결

`reload()`로 서버에서 최신 정보를 받아온 뒤, `currentUser`를 **다시 읽어서** `AppUser`로 변환하고, Provider가 `_user`에 담은 뒤 `notifyListeners()`로 UI에 알림.

```dart
// FirebaseAuthService
Future<AppUser?> reloadUser() async {
  await _auth.currentUser?.reload();
  return currentUser; // reload 후 최신 유저를 AppUser로 변환해 반환
}

// FirebaseAuthProvider
Future<void> refreshUser() async {
  _user = await _authService.reloadUser();
  notifyListeners();
}
```

| 코드 | 역할 |
| --- | --- |
| `currentUser?.reload()` | 서버에서 최신 유저 정보를 가져와 현재 `User` 객체를 갱신함. 비동기이므로 반드시 `await`로 끝날 때까지 기다려야 함 |
| `return currentUser` | `reload()` 이후의 최신 상태를 다시 읽어 `AppUser`로 변환해 반환함. 이 줄이 없으면 이미 변환해 둔 값은 여전히 이전 상태임 |
| `_user = await reloadUser()` | Provider가 보관하는 값을 최신 `AppUser`로 교체함 |
| `notifyListeners()` | `Provider`를 구독 중인 위젯들에게 상태가 바뀌었음을 알려 화면을 리빌드시킴 |

## 정리

- 유저 정보가 여러 단계에 걸쳐 완성되거나 바뀔 수 있는 시점(회원가입 직후, 프로필 수정, 인증 메일 발송 후 등)에는 `refreshUser()`를 호출해서 동기화하는 것이 안전함.
- "갱신 → 다시 읽기(재변환) → 알림" 세 단계가 한 세트라고 기억해두면 됨.
