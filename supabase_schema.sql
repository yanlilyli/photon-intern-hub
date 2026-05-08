-- ============================================
-- 光子招聘新人进阶手册 · Supabase Schema
-- ============================================

-- 用户/成员表
CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('leader', 'mentor', 'intern')),
  project TEXT DEFAULT '',
  mentor_id TEXT DEFAULT '',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 培养计划表
CREATE TABLE IF NOT EXISTS plans (
  id SERIAL PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  plan_data JSONB NOT NULL DEFAULT '[]',
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 每周Review表
CREATE TABLE IF NOT EXISTS reviews (
  id SERIAL PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  review_data JSONB NOT NULL DEFAULT '{}',
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Sourcing Track候选人表
CREATE TABLE IF NOT EXISTS candidates (
  id BIGINT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name TEXT DEFAULT '',
  project TEXT DEFAULT '',
  position TEXT DEFAULT '',
  company TEXT DEFAULT '',
  channel TEXT DEFAULT '',
  status TEXT DEFAULT '待触达',
  recommend_date TEXT DEFAULT '',
  resume_link TEXT DEFAULT '',
  comments TEXT DEFAULT '',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 系统配置表（管理员口令等）
CREATE TABLE IF NOT EXISTS config (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);

-- 启用RLS（行级安全）
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE candidates ENABLE ROW LEVEL SECURITY;
ALTER TABLE config ENABLE ROW LEVEL SECURITY;

-- 允许匿名用户读写（因为我们用姓名登录而非Supabase Auth）
CREATE POLICY "Allow all" ON users FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON plans FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON reviews FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON candidates FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON config FOR ALL USING (true) WITH CHECK (true);
