# 7. `ListTile`을 `Container`/`DecoratedBox`로 감쌀 때 뜨는 경고

[← README로 돌아가기](../README.md#트러블슈팅)

## 증상

```dart
Container(
  color: Colors.grey[200],
  child: ListTile(...),
)
```

이런 식으로 배경색을 주기 위해 `ListTile`을 `Container`나 `DecoratedBox`로 감싸면 콘솔에 경고가 뜸.

## 원인

`ListTile`은 내부적으로 `Material` 위젯을 기반으로 잉크 스플래시(탭 시 퍼지는 효과) 등을 처리하는데, `ListTile`을 색이 있는 위젯으로 감싸면 그 잉크 효과가 부모의 배경색 위에 제대로 그려지지 못하는 충돌이 발생할 수 있어서 Flutter가 경고를 띄움.

## 해결 — 방법 1

`Container`로 감싸지 말고, `ListTile` 자체의 `tileColor` 속성을 사용.

```dart
ListTile(
  tileColor: Colors.grey[200],
  ...
)
```

## 해결 — 방법 2

꼭 `Container`처럼 감싸야 하는 구조라면, `ListTile`을 `Material`로 한 번 감싸고 배경은 투명 처리.

```dart
Container(
  color: Colors.grey[200],
  child: Material(
    color: Colors.transparent,
    child: ListTile(...),
  ),
)
```
