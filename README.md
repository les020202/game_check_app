# game_check_app

여러 게임을 동시에 플레이하는 게이머를 위한 일일, 주간, 월간 퀘스트 및 목표 관리 앱입니다.

## 목차

- [기술 스택](#기술-스택)
- [환경정보](#환경정보)
- [아키텍처](#아키텍처)
- [주요 화면 및 기능](#주요-화면-및-기능)
- [트러블슈팅](#트러블슈팅)
- [실행방법](#실행방법)

## 기술 스택

- 프레임워크 : Flutter
- 상태관리 : Provider
- 라우팅 : go_router
- 로컬 DB : Drift
- 클라우드 DB : Firebase Firestore
- 인증 : Firebase Authentication
- ID 생성 : uuid (v4)
- 로컬 설정 : shared_preferences (온보딩 페이지)
- 사진 저장 : Firebase Storage

## 환경정보

### 대상 플랫폼

Android (Google Play Store)

### 로컬 DB 엔진

sqlite3 (drift 2.32+ 기준)

### Firebase 연동 (클라우드 DB, 인증, 스토리지)

Firebase 프로젝트 연동 필요 (google-services.json 등 설정 파일 별도 추가)

## 아키텍처

![아키텍처 다이어그램](images/architecture.png)

> 다이어그램 원본: [`images/architecture.excalidraw`](images/architecture.excalidraw) — [excalidraw.com](https://excalidraw.com)에서 열어 수정할 수 있습니다.

### 구조

기본적으로 pages → viewmodel → services

- pages: 순수 View. 화면 단위 위젯만 담당
- viewmodel/provider: 화면별 상태와 로직. services를 조합해 화면에 필요한 상태를 만듦
- widgets: 여러 페이지에서 공통으로 쓰이는 UI 컴포넌트 및 위젯을 한곳에 모아둔 폴더
- dialogs: 다이얼로그(AlertDialog 등)를 한곳에 모아둔 폴더
- services: 데이터 CRUD(로그인 전 Drift ↔ 로그인 후 Firestore 전환 포함)와 Firebase Auth, 로그인 마이그레이션까지 전부 이 폴더에서 처리
- local: Drift 스키마 전체 — 테이블 정의(tables/)와 커스텀 컬럼 변환기(converters/)로 구성
- theme: 앱 공통 색상 정의
- utils: 특정 화면에 종속되지 않는 유틸 함수

```
lib/
├── dialogs/    # 다이얼로그 모음
├── local/      # Drift 로컬 DB
│   ├── tables/       # Drift 테이블 정의
│   └── converters/   # 커스텀 타입 컨버터 (예: List<String> ↔ JSON)
├── models/     # 도메인 모델
├── pages/      # 화면 위젯(View)
├── services/   # 데이터 CRUD(Drift/Firestore) + 외부 동작 트리거 (Auth, 로그인 마이그레이션)
├── theme/      # 앱 공통 색상
├── utils/      # 유틸 함수
├── viewmodel/
│   └── provider/   # 화면별 로직 (Provider/ChangeNotifier), services를 조합해 상태를 만듦
└── widgets/    # 여러 화면에서 재사용하는 공용 위젯 및 위젯 모음
```

### 데이터 저장소 전환 정책

로그인 전(Drift)과 로그인 후(Firestore)는 동시에 원본 데이터로 취급하지 않으며, 로그인 시점에 로컬 데이터를 계정으로 업로드(또는 폐기)하는 마이그레이션 절차를 거쳐 저장소 주도권이 완전히 전환됩니다.

## 주요 화면 및 기능

### 게임 메인 페이지

<table>
  <tr>
    <td align="center"><img src="images/게임_메인.png" width="240" alt="게임 메인"></td>
    <td align="center"><img src="images/게임_메인_안내.png" width="240" alt="게임 메인 - 표시 기준"></td>
  </tr>
  <tr>
    <td align="center">게임 목록</td>
    <td align="center">퀘스트 완료 표시 기준</td>
  </tr>
</table>

- 내가 설정한 게임 목록 표시 (이름, 타입 및 모든 일일 퀘스트 상태)
- 더보기 아이콘 클릭 시 → 삭제 버튼 표시 및 게임 삭제
- 게임 추가 버튼 클릭 시 → 게임 설정 페이지로 이동
- 표시 기준 아이콘 클릭 시 → 퀘스트 완료 표시 기준(완료 / 부분 완료 / 미완료) 안내

### 게임 설정 페이지

<table>
  <tr>
    <td align="center"><img src="images/게임_설정_윗부분.png" width="240" alt="게임 설정 - 기본 정보"></td>
    <td align="center"><img src="images/게임_설정_중간부분.png" width="240" alt="게임 설정 - 퀘스트 및 캐릭터"></td>
    <td align="center"><img src="images/게임_설정_아랫부분.png" width="240" alt="게임 설정 - 월간 퀘스트 및 목표"></td>
  </tr>
  <tr>
    <td align="center">기본 정보 · 초기화 설정</td>
    <td align="center">일일 퀘스트 · 캐릭터별 설정</td>
    <td align="center">월간 퀘스트 · 목표</td>
  </tr>
</table>

- 게임 설정 입력
  - 이름, 타입, 초기화 시간, 주간 초기화 요일
  - 캐릭터, 공통 일일 퀘스트
  - 캐릭터별 주간 / 월간 퀘스트 및 목표
- 템플릿 불러오기 선택 및 적용 (미리 입력된 템플릿을 불러와서 적용)
- 설정 완료 버튼 클릭 시 → 설정 내용 저장

### 게임 상세 페이지

<table>
  <tr>
    <td align="center"><img src="images/게임_상세_윗부분.png" width="240" alt="게임 상세 - 캘린더"></td>
    <td align="center"><img src="images/게임_상세_아랫부분.png" width="240" alt="게임 상세 - 퀘스트 체크"></td>
  </tr>
  <tr>
    <td align="center">캘린더 · 전체 일일 퀘스트</td>
    <td align="center">캐릭터별 퀘스트 체크</td>
  </tr>
</table>

- 설정한 퀘스트(일일, 주간, 월간, 목표) 체크
  - 일일 퀘스트: 공통 퀘스트로, 같은 퀘스트를 캐릭터마다 각각 체크
  - 주간 / 월간 / 목표: 캐릭터마다 각각 체크
- 캘린더의 날짜 클릭 시 → 주간 현황 페이지로 이동

### 주간 현황 페이지

<img src="images/주간현황페이지.png" width="240" alt="주간 현황">

- 게임 체크 주간 현황 표시
- 1주일간 모든 캐릭터의 일일 퀘스트 / 주간 퀘스트 진행 상태 표시

### 로그인 페이지

<table>
  <tr>
    <td align="center"><img src="images/로그인.png" width="240" alt="로그인"></td>
    <td align="center"><img src="images/로컬-서버_이전.png" width="240" alt="로컬 데이터 이전"></td>
  </tr>
  <tr>
    <td align="center">로그인</td>
    <td align="center">기기 데이터 이전 선택</td>
  </tr>
</table>

- 이메일, 비밀번호 입력 후 로그인
- 구글 소셜 로그인 버튼 클릭 시 → 소셜 로그인
- 기기에 저장된 데이터가 있으면 → 계정에 저장 / 버리기 / 로그인 취소 중 선택 ([데이터 저장소 전환 정책](#데이터-저장소-전환-정책))

### 회원가입 페이지

<img src="images/회원가입.png" width="240" alt="회원가입">

- 닉네임, 이메일, 비밀번호 입력 및 약관 동의 후 가입

### 마이 페이지

<img src="images/마이페이지.png" width="240" alt="마이페이지">

- 프로필 사진, 닉네임, 이메일 표시
- 프로필 사진 클릭 시 사진 적용, 닉네임 변경
- 자주 묻는 질문, 고객센터, 이용약관 페이지로 이동
- 이메일 인증, 로그인 / 로그아웃, 회원 탈퇴

### 그 외 화면

비밀번호 재설정, 메일 확인, 자주 묻는 질문, 고객센터, 문의, 이용약관, 이용약관 상세, 온보딩 페이지

## 트러블슈팅

각 항목을 클릭하면 상세 내용(증상 · 원인 · 해결)을 볼 수 있습니다.

### 1. [`game_setup_page`에서 고정 크기 위젯의 오버플로우](docs/01-column-overflow.md)

캐릭터/퀘스트 항목을 계속 추가하면 고정 크기 영역을 넘어 오버플로우 에러가 발생함.
`Column`의 기본값 `MainAxisSize.max` 때문에 부모가 고정한 크기를 넘어설 수 없었던 것이 원인.
`mainAxisSize: MainAxisSize.min`으로 자식 크기만큼만 차지하도록 바꿔 해결.

### 2. [`TableCalendar` 사용법 (`onDaySelected`)](docs/02-table-calendar.md)

날짜를 선택해도 캘린더의 포커스(보여주는 달)는 자동으로 갱신되지 않음.
`focusedDay`(보여주는 달)와 `selectedDay`(선택한 날짜)는 별개의 값으로 관리됨.
`onDaySelected`의 `setState` 안에서 두 값을 모두 갱신해 해결.

### 3. [`Expanded` 안에서 고정 크기 위젯이 잘리는 문제](docs/03-expanded-tight-constraint.md)

`Expanded` 안의 고정 크기 `Container`가 지정한 크기대로 표시되지 않고 잘리거나 찌그러짐.
`Expanded`가 자식에게 tight constraint를 전달해 크기를 강제하는 것이 원인.
`Center`로 한 번 감싸 loose constraint로 바꿔 원래 크기를 유지하도록 해결.

### 4. [`ListTile`을 `Container`로 감쌀 때 뜨는 경고](docs/04-listtile-container-warning.md)

배경색을 주려고 `ListTile`을 `Container`/`DecoratedBox`로 감싸면 콘솔에 경고가 뜸.
`ListTile`의 잉크 효과가 부모의 배경색 위에 제대로 그려지지 못하는 충돌이 원인.
`tileColor` 속성을 사용하거나, `Material(color: Colors.transparent)`로 감싸서 해결.

### 5. [높이 제약 없는 곳의 `ListView` 오류 및 중첩 스크롤](docs/05-listview-unbounded-height.md)

`Column`/`SingleChildScrollView` 안의 `ListView`가 레이아웃 에러를 내거나 스크롤이 이중으로 동작함.
`ListView`는 무한한 공간을 요구하는데 부모는 높이 제약을 주지 않아 서로 크기를 미루는 것이 원인.
`Expanded`로 감싸거나 `shrinkWrap` + `NeverScrollableScrollPhysics` 조합으로 해결.

### 6. [`TextFormField` 여러 줄 입력](docs/06-textformfield-multiline.md)

문의 작성처럼 긴 텍스트를 입력받아야 하는데 기본 `TextFormField`는 한 줄짜리 입력창임.
`minLines`, `maxLines`로 입력창 높이를 정하고, 키보드 타입과 엔터 동작을 줄바꿈용으로 설정.
`hintMaxLines`로 긴 힌트 텍스트도 여러 줄로 표시되도록 처리.

### 7. [스크롤 시 내부 위젯이 흔들리는 문제 (오버스크롤 글로우)](docs/07-overscroll-glow.md)

스크롤을 끝까지 당기면 안쪽 위젯이 잠깐 어긋나거나 커지는 듯 흔들려 보임.
안드로이드 기본 오버스크롤 글로우 효과가 레이아웃 리사이즈처럼 작동하는 것이 원인.
`ScrollConfiguration`으로 감싸고 `overscroll: false`로 효과를 꺼서 해결.

### 8. [Firebase Auth `reload()` 후 최신 유저 정보 반영](docs/08-firebase-auth-reload.md)

회원가입 직후 마이페이지에 이메일은 보이는데 닉네임이 비어 있음 (재로그인 시 정상 표시).
`currentUser`는 스냅샷이라 `reload()` 후 다시 읽어 변환하지 않으면 Provider 값이 예전 상태로 남음.
"`reload()` → `currentUser` 재변환 → `notifyListeners()`" 흐름의 `refreshUser()`로 해결.

### 9. [로그인 상태에 따른 저장소 전환 (서비스 분리 + `ProxyProvider`)](docs/09-storage-switch-proxyprovider.md)

로그인 전에는 Drift, 로그인 후에는 Firestore에 저장해야 해서 Provider 곳곳에 분기문이 생김.
`GameService` 공통 인터페이스 아래 `DriftGameService` / `FirestoreGameService`로 저장소 구현을 분리.
`ChangeNotifierProxyProvider`로 로그인 상태가 실제로 바뀔 때만 알맞은 서비스를 주입해 해결.

## 실행방법

### 1. 패키지 설치

```bash
flutter pub get
```

### 2. Drift 코드 생성 (테이블 정의 변경 시 반드시 재실행)

```bash
dart run build_runner build --delete-conflicting-outputs
```

개발 중에는 watch 모드를 사용합니다.

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### 3. 앱 실행 (Android)

```bash
flutter run
```
