-- ============================================================
-- 남현교회 중등부 홈페이지 - Supabase DB 스키마
-- Supabase 대시보드 → SQL Editor → 아래 코드 실행
-- ============================================================

-- 1. posts 테이블 (공지/주보/설교/찬양)
CREATE TABLE IF NOT EXISTS posts (
  id         UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  type       TEXT NOT NULL CHECK (type IN ('bulletin','sermon','praise','notice')),
  title      TEXT NOT NULL,
  date       DATE NOT NULL,
  content    TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 2. schedules 테이블 (연간 일정)
CREATE TABLE IF NOT EXISTS schedules (
  id         UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  date       DATE NOT NULL,
  title      TEXT NOT NULL,
  tag        TEXT NOT NULL DEFAULT '예배'
             CHECK (tag IN ('예배','수련회','행사','시험기간','특별')),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ── RLS (Row Level Security) 설정 ──────────────────────────
-- 공개 읽기 허용 (홈페이지에서 데이터 조회)
ALTER TABLE posts     ENABLE ROW LEVEL SECURITY;
ALTER TABLE schedules ENABLE ROW LEVEL SECURITY;

-- 누구나 읽기 가능 (public SELECT)
CREATE POLICY "public read posts"
  ON posts FOR SELECT USING (true);

CREATE POLICY "public read schedules"
  ON schedules FOR SELECT USING (true);

-- anon 키로 쓰기 가능 (관리자 페이지에서 INSERT/DELETE)
-- ※ 실제 운영 시에는 Service Role Key를 서버에서만 사용하거나
--    Supabase Auth로 인증된 사용자만 허용하는 것을 권장
CREATE POLICY "anon write posts"
  ON posts FOR ALL USING (true);

CREATE POLICY "anon write schedules"
  ON schedules FOR ALL USING (true);

-- ── 인덱스 (성능 최적화) ───────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_posts_date     ON posts     (date DESC);
CREATE INDEX IF NOT EXISTS idx_posts_type     ON posts     (type);
CREATE INDEX IF NOT EXISTS idx_schedules_date ON schedules (date ASC);

-- ── 샘플 데이터 삽입 ────────────────────────────────────────
INSERT INTO posts (type, title, date, content) VALUES
  ('bulletin', '2026년 6월 2주 주보 (6.14)', '2026-06-14',
   E'성경봉독: 고린도전서 2장 10-16절\n설교: 성령님을 의지하며 배움\n결단: 주님을 예배하는 것 다시 일어나'),
  ('notice', '여름수련회 안내 (7/29~31)', '2026-06-10',
   E'장소: 가평 오름비전빌리지\nQR 코드로 신청해주시기 바랍니다.'),
  ('sermon', '성령님을 의지하며 배움', '2026-06-14',
   'https://youtube.com/playlist?list=PLnH9HulIMcJeJDKi0oPVAk0lEQ-kGxFiJ'),
  ('notice', '중등부 예배 캠페인', '2026-06-01',
   E'1. 예배시간 10분 전에 오기!\n2. 공예배(1부 또는 2부) 드리기!\n3. 준비된 헌금으로 하나님께 드리기!\n4. 예배는 공과 공부까지!\n5. 예배시간에 핸드폰 No! No! No!');

INSERT INTO schedules (date, title, tag) VALUES
  ('2026-06-14', '반별 대심방 3학년 4반', '예배'),
  ('2026-06-21', '중등부 친구초청잔치',    '행사'),
  ('2026-06-28', '반별 대심방 3학년 5반', '예배'),
  ('2026-07-29', '여름수련회 1일차 (가평)', '수련회'),
  ('2026-07-30', '여름수련회 2일차',       '수련회'),
  ('2026-07-31', '여름수련회 3일차',       '수련회'),
  ('2026-09-20', '중등부 체육대회',        '행사'),
  ('2026-12-25', '성탄절 특별 예배',       '특별');

-- ============================================================
-- 확인 쿼리
-- ============================================================
SELECT 'posts: ' || COUNT(*) FROM posts;
SELECT 'schedules: ' || COUNT(*) FROM schedules;
