## game_check_app
# 게임 체크 앱 개발 프로젝트
여러 게임을 동시에 플레이하는 게이머를 위한 일일,주간,월간 퀘스트 및 목표 관리 앱입니다.


## 기술 스택
프레임워크 : Flutter
상태관리 : Provider
라우팅 : go_router
로컬 DB : Drift
클라우드 DB : Firebase Firestore
인증 : Firebase Authentication
ID 생성 : uuid (v4)
캘린더 : table_calendar
기타 UI : dotted_border(점선 위젯)
로컬 설정 : shared_preferences(온보딩 페이지)
갤러리 기능 : image_picker
사진 저장 : Firebase Storage

문의 이메일 발송 : (예정)
알림설정 : (예정)


## 실행방법
# 1. 패키지 설치
flutter pub get

# 2. Drift 코드 생성 (테이블 정의 변경 시 반드시 재실행)
dart run build_runner build --delete-conflicting-outputs
개발 중에는 아래 코드로 사용 watch모드
dart run build_runner watch --delete-conflicting-outputs

# 3. 앱 실행 (Android)
flutter run


## 환경정보
# 대상 플랫폼
Android (Google Play Store)

# 로컬 DB 엔진
sqlite3 (drift 2.32+ 기준)

# Firebase 연동 (클라우드 DB, 인증, 스토리지)
Firebase 프로젝트 연동 필요(google-services.json 등 설정 파일 별도 추가)

## 아키텍처
# 구조
기본적으로 pages → viewmodel → services

pages: 순수 View. 화면 단위 위젯만 담당
viewmodel/provider: 화면별 상태와 로직. services를 조합해 화면에 필요한 상태를 만듦
widgets: 여러 페이지에서 공통으로 쓰이는 UI 컴포넌트
services: 데이터 CRUD(로그인 전 Drift ↔ 로그인 후 Firestore 전환 포함)와 Firebase Auth, 로그인 마이그레이션, 문의 이메일 발송(예정), 알림(예정)까지 전부 이 폴더에서 처리
local: Drift 스키마 전체 — 테이블 정의(tables/)와 커스텀 컬럼 변환기(converters/)로 구성

lib/
├── models/     # 도메인 모델
├── pages/      # 화면 위젯(View)
├── viewmodel/
│   └── provider/   # 화면별 로직 (Provider/ChangeNotifier), services를 조합해 상태를 만듦
├── widgets/    # 여러 화면에서 재사용하는 공용 위젯
├── services/   # 데이터 CRUD(Drift/Firestore) + 외부 동작 트리거 (Auth, 로그인 마이그레이션, 문의 이메일 발송(예정), 알림(예정))
└── local/      # Drift 로컬 DB
    ├── tables/       # Drift 테이블 정의
    └── converters/   # 커스텀 타입 컨버터 (예: List<String> ↔ JSON)

# 데이터 저장소 전환 정책
로그인 전(Drift)과 로그인 후(Firestore)는 동시에 원본 데이터로 취급하지 않으며, 로그인 시점에 로컬 데이터를 계정으로 업로드(또는 폐기)하는 마이그레이션 절차를 거쳐 저장소 주도권이 완전히 전환됩니다.


