-- ==============================================================================
-- FITMORPH AI - BACKEND DATABASE SCHEMA (SUPABASE POSTGRESQL + RLS)
-- ==============================================================================

-- Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. PROFILES (Extende auth.users do Supabase)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    age INT,
    gender TEXT CHECK (gender IN ('male', 'female', 'other')),
    weight_kg NUMERIC(5, 2),
    height_cm NUMERIC(5, 2),
    experience_level TEXT CHECK (experience_level IN ('beginner', 'intermediate', 'advanced')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. ANAMNESIS RECORDS
CREATE TABLE IF NOT EXISTS public.anamnesis_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    primary_goal TEXT NOT NULL, -- 'hypertrophy', 'fatLoss', 'recomposition'
    days_per_week INT NOT NULL,
    available_minutes_per_session INT NOT NULL,
    workout_location TEXT NOT NULL, -- 'commercialGym', 'homeGym'
    joint_pains TEXT[] DEFAULT '{}',
    preferred_muscles TEXT[] DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. WORKOUT PLANS
CREATE TABLE IF NOT EXISTS public.workout_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    split_type TEXT NOT NULL, -- 'Push / Pull / Legs', 'Upper / Lower'
    description TEXT,
    weekly_volume_per_muscle JSONB DEFAULT '{}'::jsonb,
    is_ai_generated BOOLEAN DEFAULT true,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. WORKOUT DAYS
CREATE TABLE IF NOT EXISTS public.workout_days (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    plan_id UUID REFERENCES public.workout_plans(id) ON DELETE CASCADE NOT NULL,
    day_letter TEXT NOT NULL, -- 'A', 'B', 'C', 'D'
    title TEXT NOT NULL,
    focus_muscles TEXT[] DEFAULT '{}',
    estimated_minutes INT DEFAULT 60,
    sort_order INT DEFAULT 1
);

-- 5. WORKOUT EXERCISES
CREATE TABLE IF NOT EXISTS public.workout_exercises (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    day_id UUID REFERENCES public.workout_days(id) ON DELETE CASCADE NOT NULL,
    exercise_catalog_id TEXT NOT NULL,
    name TEXT NOT NULL,
    target_muscle TEXT NOT NULL,
    sets_count INT NOT NULL DEFAULT 3,
    reps_range TEXT NOT NULL DEFAULT '8-12',
    rpe_target TEXT NOT NULL DEFAULT 'RPE 8 / RIR 2',
    rest_seconds INT NOT NULL DEFAULT 90,
    notes TEXT,
    equipment TEXT NOT NULL DEFAULT 'Halteres',
    is_supersing BOOLEAN DEFAULT false,
    superset_group TEXT,
    substitute_ids TEXT[] DEFAULT '{}',
    sort_order INT DEFAULT 1
);

-- 6. WORKOUT SESSIONS (Treinos Ativos Concluídos)
CREATE TABLE IF NOT EXISTS public.workout_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    day_id UUID REFERENCES public.workout_days(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    elapsed_seconds INT NOT NULL,
    total_volume_kg NUMERIC(10, 2) DEFAULT 0,
    completed_sets INT DEFAULT 0,
    total_sets INT DEFAULT 0,
    estimated_calories INT DEFAULT 0,
    started_at TIMESTAMP WITH TIME ZONE NOT NULL,
    ended_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 7. SESSION EXERCISE LOGS
CREATE TABLE IF NOT EXISTS public.session_exercise_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID REFERENCES public.workout_sessions(id) ON DELETE CASCADE NOT NULL,
    exercise_name TEXT NOT NULL,
    set_number INT NOT NULL,
    target_reps INT NOT NULL,
    completed_reps INT NOT NULL,
    weight_kg NUMERIC(6, 2) NOT NULL,
    rpe_real INT
);

-- 8. BODY ASSESSMENTS (Biometria Visual & Antes/Depois)
CREATE TABLE IF NOT EXISTS public.body_assessments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    weight_kg NUMERIC(5, 2) NOT NULL,
    body_fat_percentage NUMERIC(4, 2),
    waist_cm NUMERIC(5, 2),
    chest_cm NUMERIC(5, 2),
    arm_cm NUMERIC(5, 2),
    thigh_cm NUMERIC(5, 2),
    front_photo_storage_path TEXT,
    back_photo_storage_path TEXT,
    somatotype TEXT,
    ai_feedback TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ==============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ==============================================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.anamnesis_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_days ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.session_exercise_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.body_assessments ENABLE ROW LEVEL SECURITY;

-- Profiles: Usuário só acessa e edita seu próprio perfil
CREATE POLICY "Users can view own profile" ON public.profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- Anamnesis: Acesso estrito por usuário
CREATE POLICY "Users can manage own anamnesis" ON public.anamnesis_records FOR ALL USING (auth.uid() = user_id);

-- Workout Plans: Acesso estrito
CREATE POLICY "Users can manage own workout plans" ON public.workout_plans FOR ALL USING (auth.uid() = user_id);

-- Workout Sessions & Logs: Acesso estrito
CREATE POLICY "Users can manage own workout sessions" ON public.workout_sessions FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can manage own body assessments" ON public.body_assessments FOR ALL USING (auth.uid() = user_id);

-- ==============================================================================
-- SUPABASE STORAGE BUCKET CONFIGURATION (Private Encrypted Bucket)
-- ==============================================================================

INSERT INTO storage.buckets (id, name, public) 
VALUES ('body-photos', 'body-photos', false)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "Users can upload own body photos" 
ON storage.objects FOR INSERT 
WITH CHECK (bucket_id = 'body-photos' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can view own body photos" 
ON storage.objects FOR SELECT 
USING (bucket_id = 'body-photos' AND auth.uid()::text = (storage.foldername(name))[1]);
