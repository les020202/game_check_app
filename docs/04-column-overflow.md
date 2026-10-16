# 4. `game_setup_page`에서 고정 크기 위젯의 오버플로우 문제

[← README로 돌아가기](../README.md#트러블슈팅)

## 증상

게임 설정 페이지에서 캐릭터/퀘스트 항목을 "추가" 버튼으로 계속 추가하다 보면, `Container` 등으로 고정 크기를 지정해둔 영역의 콘텐츠가 넘쳐서 화면 밖으로 잘리거나 오버플로우 에러(노란/검은 줄무늬)가 발생함.

## 원인

`Column`의 기본 `mainAxisSize`는 `MainAxisSize.max`라서, 부모가 명시적으로 크기를 고정해두면 자식이 늘어나도 그 크기를 넘어설 수 없음. 항목이 동적으로 추가되는 리스트를 고정 높이 컨테이너 안에 넣으면 필연적으로 발생하는 문제.

## 해결

```dart
Column(
  mainAxisSize: MainAxisSize.min,
  children: [...],
)
```

`mainAxisSize: MainAxisSize.min`을 설정하면 `Column`이 자식들이 실제로 필요로 하는 높이만큼만 차지하도록 바뀜. 항목이 늘어나면 `Column` 자체의 높이도 함께 가변적으로 늘어나서 해결됨.
