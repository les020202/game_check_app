# 2. `TableCalendar` 위젯 사용법 (특히 `onDaySelected`)

[← README로 돌아가기](../README.md#트러블슈팅)

`table_calendar` 패키지로 캘린더 UI를 구현할 때 알아야 하는 핵심 속성들.

## 핵심 속성

- **`focusedDay`**: 캘린더가 현재 어느 달/주를 보여주고 있는지 결정하는 기준 날짜. 사용자가 날짜를 선택해도 자동으로 갱신되지 않으므로, `onDaySelected` 콜백 안에서 직접 상태를 갱신해줘야 함.
- **`selectedDayPredicate`**: 어떤 날짜를 "선택된 날짜"로 표시(하이라이트)할지 결정하는 함수. 내부 상태(`_selectedDay`)와 캘린더가 렌더링하는 날짜를 비교해서 `true`/`false` 반환.
- **`onDaySelected: (selectedDay, focusedDay)`**: 날짜를 탭했을 때 호출됨. 콜백 인자로 `selectedDay`(사용자가 실제 선택한 날짜)와 `focusedDay`(그 달력이 포커스하고 있는 날짜)가 둘 다 넘어오므로, `setState` 안에서 둘 다 갱신해줘야 다음 렌더링에서 정상적으로 반영됨.

```dart
onDaySelected: (selectedDay, focusedDay) {
  setState(() {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay; // 이것도 같이 갱신해야 함
  });
},
```

## 왜 두 값을 분리해서 관리하는가

"달력이 보여주는 달(포커스)"과 "사용자가 클릭한 날짜(선택)"가 항상 같지 않을 수 있기 때문(예: 이전 달 날짜를 눌렀을 때 캘린더가 그 달로 넘어가는 경우 등).
