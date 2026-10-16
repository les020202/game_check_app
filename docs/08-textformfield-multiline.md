# 8. `TextFormField`에서 여러 줄 입력이 필요한 경우

[← README로 돌아가기](../README.md#트러블슈팅)

## 증상

문의 작성, 메모 등 긴 텍스트를 입력받아야 하는 필드에서 기본 `TextFormField`는 한 줄짜리 입력창으로 표시됨.

## 해결

```dart
TextFormField(
  minLines: 5,
  maxLines: 8,
  keyboardType: TextInputType.multiline,
  textInputAction: TextInputAction.newline,
  decoration: const InputDecoration(
    hintText: '문의 내용을 입력해주세요',
    hintMaxLines: 5,
  ),
)
```

| 속성 | 역할 |
| --- | --- |
| `minLines: 5` | 처음부터 5줄 높이로 넓게 표시되어, "여기 길게 써도 된다"는 느낌을 시각적으로 줌 |
| `maxLines: 8` | 사용자가 계속 입력하면 8줄까지는 자동으로 늘어나고, 그 이상은 내부 스크롤로 처리됨 |
| `keyboardType: TextInputType.multiline` | 모바일 키보드가 줄바꿈 입력에 적합한 형태로 바뀜 |
| `textInputAction: TextInputAction.newline` | 키보드의 완료/다음 버튼 대신, 엔터 키가 줄바꿈으로 동작하게 함 |
| `hintMaxLines: 5` | 힌트 텍스트가 길 경우 한 줄로 잘리지 않고 여러 줄로 표시되게 함 |
