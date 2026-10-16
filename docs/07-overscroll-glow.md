# 7. 스크롤 시 내부 위젯이 어긋나거나 커지는 문제 (오버스크롤 글로우)

[← README로 돌아가기](../README.md#트러블슈팅)

## 증상

`SingleChildScrollView`나 `ListView`처럼 스크롤이 가능한 위젯을 화면 끝까지 당기거나(오버스크롤) 할 때, 안쪽 위젯들이 잠깐 어긋나거나 커지는 듯한 시각적 흔들림이 발생함.

## 원인

안드로이드 기본 스크롤 동작에는 스크롤이 끝에 도달했을 때 나타나는 "글로우(glow)" 오버스크롤 효과가 있는데, 이 효과가 레이아웃 리사이즈처럼 작동하면서 내부 위젯들의 크기/위치가 미세하게 흔들리는 것처럼 보이는 문제를 유발할 수 있음.

## 해결

```dart
ScrollConfiguration(
  behavior: ScrollConfiguration.of(context).copyWith(
    overscroll: false,
  ),
  child: SingleChildScrollView(
    child: ...,
  ),
)
```

`ScrollConfiguration`으로 감싸고 `overscroll: false`를 지정해서 오버스크롤 글로우 효과 자체를 꺼버리면 해결됨.
