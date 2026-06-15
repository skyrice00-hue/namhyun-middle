# 남현교회 중등부 홈페이지 v2

## 파일 구조
```
namhyun-middle/
├── index.html           ← 메인 홈페이지 (공개)
├── admin.html           ← 관리자 페이지 (비밀번호 보호)
├── supabase-schema.sql  ← DB 테이블 생성 SQL
├── vercel.json          ← Vercel 배포 설정
└── README.md
```

---

## STEP 1 · GitHub 저장소 만들기

1. https://github.com 로그인
2. 오른쪽 상단 **+** → **New repository**
3. Repository name: `namhyun-middle`
4. **Public** 선택 → **Create repository**
5. "uploading an existing file" 클릭
6. 파일 4개 드래그 앤 드롭: `index.html` `admin.html` `vercel.json` `README.md`
7. **Commit changes** 클릭

---

## STEP 2 · Supabase DB 설정

### 2-1. 프로젝트 생성
1. https://supabase.com → **Start your project** → GitHub 로그인
2. **New project** → Organization 선택
3. Name: `namhyun-middle`
4. Database Password: 안전한 비밀번호 입력 (저장해두기)
5. Region: **Northeast Asia (Seoul)** 선택
6. **Create new project** (약 2분 대기)

### 2-2. 테이블 생성
1. 좌측 메뉴 → **SQL Editor**
2. `supabase-schema.sql` 파일 내용 전체 복사 후 붙여넣기
3. **Run** 클릭 → "posts: 4 / schedules: 8" 메시지 확인

### 2-3. API 키 복사
1. 좌측 메뉴 → **Settings** → **API**
2. **Project URL** 복사 → `index.html`과 `admin.html`의 `CFG.SUPABASE_URL`에 붙여넣기
3. **anon public** 키 복사 → `CFG.SUPABASE_KEY`에 붙여넣기

```javascript
// index.html 하단 CFG 수정
const CFG = {
  SUPABASE_URL: 'https://abcdefgh.supabase.co',   // ← 여기
  SUPABASE_KEY: 'eyJhbGciOiJIUzI1NiIs...',         // ← 여기
  GCAL_URL:     'YOUR_GOOGLE_CALENDAR_EMBED_URL',
};
```

> ⚠️ **admin.html의 CFG도 동일하게 수정하세요!**

4. 수정한 파일을 GitHub에 다시 업로드 (기존 파일 덮어쓰기)

---

## STEP 3 · Vercel 배포

1. https://vercel.com → **GitHub으로 로그인**
2. **Add New Project** → GitHub 저장소 `namhyun-middle` 선택
3. **Import** → 설정 변경 없이 **Deploy** 클릭
4. 약 30초 후 배포 완료!

### 무료 도메인 자동 발급
```
https://namhyun-middle.vercel.app
https://namhyun-middle.vercel.app/admin
```

### 커스텀 도메인 연결 (선택)
- Vercel 프로젝트 → Settings → Domains → 도메인 추가

---

## STEP 4 · 구글 캘린더 연동

1. https://calendar.google.com 접속
2. 왼쪽 하단 **+ 다른 캘린더** → **새 캘린더 만들기**
3. 이름: `남현교회 중등부`
4. 캘린더 설정 → **액세스 권한** → **공개 사용 설정** 체크
5. **캘린더 통합** → **임베드 코드** 복사
6. `src="..."` 안의 URL만 복사
7. 관리자 페이지 로그인 → **구글 캘린더 설정** → URL 붙여넣기 → 저장

---

## 관리자 사용법

| 항목 | 내용 |
|------|------|
| 초기 비밀번호 | `namhyun2026` |
| 관리자 URL | `여러분사이트.vercel.app/admin` |
| 데이터 저장 | Supabase (모든 기기 동기화) |
| 비밀번호 | 브라우저 로컬 저장 (변경 권장) |

**첫 로그인 후 반드시 비밀번호를 변경하세요!**

---

## 업데이트 방법

### 공지/일정 추가·삭제
→ 관리자 페이지에서 직접 수정 (GitHub 불필요)

### 디자인·구조 변경
1. GitHub에서 파일 직접 수정 (웹 편집 가능)
2. Commit → Vercel이 자동으로 30초 내 재배포

---

## DB 구조 (Supabase)

### posts 테이블
| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | UUID | 자동 생성 |
| type | TEXT | bulletin / sermon / praise / notice |
| title | TEXT | 제목 |
| date | DATE | 날짜 |
| content | TEXT | 내용 또는 유튜브 URL |
| created_at | TIMESTAMPTZ | 생성 시각 |

### schedules 테이블
| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | UUID | 자동 생성 |
| date | DATE | 행사 날짜 |
| title | TEXT | 행사명 |
| tag | TEXT | 예배 / 수련회 / 행사 / 시험기간 / 특별 |
| created_at | TIMESTAMPTZ | 생성 시각 |
