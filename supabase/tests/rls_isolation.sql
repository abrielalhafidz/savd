-- Sprint 2 RLS integration test.
-- Run with: pnpm dlx supabase db query --linked --file supabase/tests/rls_isolation.sql
-- The transaction is always rolled back: no test users or transactions persist.

BEGIN;

INSERT INTO auth.users (
  id,
  instance_id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at
)
VALUES
  (
    '10000000-0000-0000-0000-000000000001',
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'sprint2-user-a@example.invalid',
    '$2a$10$testpasswordhashthatwillneverbeused0000000000000000000',
    now(),
    '{"provider":"email","providers":["email"]}',
    '{}',
    now(),
    now()
  ),
  (
    '20000000-0000-0000-0000-000000000002',
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'sprint2-user-b@example.invalid',
    '$2a$10$testpasswordhashthatwillneverbeused0000000000000000000',
    now(),
    '{"provider":"email","providers":["email"]}',
    '{}',
    now(),
    now()
  );

SET LOCAL ROLE authenticated;
SELECT set_config('request.jwt.claim.sub', '10000000-0000-0000-0000-000000000001', true);

INSERT INTO public.transactions (user_id, category_id, type, amount, description, date)
VALUES (
  '10000000-0000-0000-0000-000000000001',
  (
    SELECT id
    FROM public.categories
    WHERE user_id = '10000000-0000-0000-0000-000000000001'
    ORDER BY created_at
    LIMIT 1
  ),
  'expense',
  12.50,
  'RLS test transaction',
  CURRENT_DATE
);

SELECT set_config('request.jwt.claim.sub', '20000000-0000-0000-0000-000000000002', true);

DO $$
DECLARE
  visible_transactions INTEGER;
BEGIN
  SELECT count(*)
  INTO visible_transactions
  FROM public.transactions
  WHERE user_id = '10000000-0000-0000-0000-000000000001';

  IF visible_transactions <> 0 THEN
    RAISE EXCEPTION 'RLS failure: User B can read User A transactions';
  END IF;
END;
$$;

ROLLBACK;
