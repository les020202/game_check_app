enum DayQuestStatus {
  complete,    // 전체 완료 — 등록된 모든 캐릭터가 그날 일일 퀘스트를 전부 체크함
  partial,     // 부분 완료 — 일부 캐릭터만 완료함
  incomplete,  // 미완료 — 지나간 날인데 아무도 완료 안 함
  upcoming,    // 예정 — 아직 오지 않은 미래 날짜 (완료 여부를 판정할 수 없음)
}