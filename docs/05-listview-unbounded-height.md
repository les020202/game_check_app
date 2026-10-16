# 5. 높이 제약이 없는 곳에 놓인 `ListView`의 오류 및 스크롤 중복 문제

[← README로 돌아가기](../README.md#트러블슈팅)

## 증상

`Column` 안이나 `SingleChildScrollView` 안에 `ListView`를 그냥 넣으면:

- `RenderBox was not laid out` 류의 레이아웃 에러가 발생하거나
- 에러 없이 동작해도, 바깥 스크롤 영역과 `ListView`의 스크롤이 서로 별도로 작동해서 스크롤이 두 번씩 되는 듯한 어색한 동작(중첩 스크롤)이 발생함

## 원인

`ListView`는 기본적으로 "부모가 준 만큼의 무한한 공간"을 채우려는 위젯인데, `Column`이나 `SingleChildScrollView`는 자식에게 높이 제약을 주지 않음(스스로도 내용물만큼만 차지하려고 함). 서로 "네가 크기를 정해줘"라고 미루는 상황이 되어 레이아웃이 깨짐.

## 해결 1 — `Expanded` 사용

바깥이 `Column`이고 그 영역을 꽉 채워도 되는 경우라면 `Expanded`로 감싸서 남은 공간을 명확히 지정.

```dart
Column(
  children: [
    ...,
    Expanded(child: ListView(...)),
  ],
)
```

## 해결 2 — `shrinkWrap` + `physics` 조합

바깥이 `SingleChildScrollView`처럼 이미 스크롤을 담당하는 위젯이고, `ListView`는 그 안에서 자기 콘텐츠 크기만큼만 차지해야 하는 경우.

```dart
ListView(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  children: [...],
)
```

- **`shrinkWrap: true`**: `ListView`가 무한한 공간을 요구하지 않고, 자식 아이템들의 실제 크기만큼만 높이를 차지하도록 함. (이게 빠지면 `hasSize` 관련 에러가 남)
- **`physics: NeverScrollableScrollPhysics()`**: 이 `ListView` 자체는 스크롤되지 않도록 막아서, 스크롤 동작을 전부 바깥의 부모 위젯(`SingleChildScrollView` 등)에게 넘겨줌. 이걸 빼먹으면 중첩 스크롤 문제가 발생함.

## 참고 — `TableCalendar`의 경우

`TableCalendar`는 `physics` 속성이 따로 없어서, 위 방법 대신 아래 속성으로 스와이프 제스처 자체를 꺼서 부모 스크롤과의 충돌을 막을 수 있음.

```dart
TableCalendar(
  availableGestures: AvailableGestures.none,
  ...
)
```
