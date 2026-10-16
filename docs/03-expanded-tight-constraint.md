# 3. `Expanded` 안에서 고정 크기 위젯이 일부 잘리는 문제

[← README로 돌아가기](../README.md#트러블슈팅)

## 증상

`Expanded`로 감싼 영역 안에 고정 크기(`width`/`height` 지정)의 `Container` 등을 넣으면, 의도한 크기로 표시되지 않고 일부가 잘리거나 찌그러져 보임.

## 원인

`Expanded`는 자식에게 **tight constraint**(꽉 맞는 제약, 정확히 이 크기여야 한다)를 전달함. 그래서 자식이 아무리 `width: 100`처럼 명시해도, 부모가 강제하는 크기(`Expanded`가 차지한 영역 전체)에 맞춰 늘어나거나 줄어들어 버림.

## 해결

```dart
Expanded(
  child: Center(
    child: Container(
      width: 100,
      height: 100,
      // ...
    ),
  ),
)
```

`Center` 위젯으로 한 번 감싸주면, `Center`가 자식에게 **loose constraint**(느슨한 제약, 최대 크기 이하라면 자유롭게 크기를 정해도 됨)로 바꿔서 전달함. 덕분에 안쪽 `Container`가 원래 지정한 크기(`width: 100, height: 100`)를 그대로 유지하면서, 할당된 영역 안에서 가운데 정렬됨.
