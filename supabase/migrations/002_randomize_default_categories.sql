-- Give every new user a distinct-looking set of starter categories while
-- preserving the same category names required throughout the application.

CREATE OR REPLACE FUNCTION public.random_default_category_color()
RETURNS TEXT
LANGUAGE sql
VOLATILE
SET search_path = public
AS $$
  SELECT (ARRAY[
    '#ef4444', '#f97316', '#eab308', '#22c55e', '#06b6d4',
    '#3b82f6', '#8b5cf6', '#ec4899', '#14b8a6', '#64748b'
  ])[1 + floor(random() * 10)::INTEGER];
$$;

CREATE OR REPLACE FUNCTION public.random_default_category_icon(category_name TEXT)
RETURNS TEXT
LANGUAGE plpgsql
VOLATILE
SET search_path = public
AS $$
BEGIN
  CASE category_name
    WHEN 'Food' THEN RETURN (ARRAY['🍔', '🍜', '🍕', '🥗'])[1 + floor(random() * 4)::INTEGER];
    WHEN 'Transportation' THEN RETURN (ARRAY['🚗', '🚌', '🚆', '🚲'])[1 + floor(random() * 4)::INTEGER];
    WHEN 'Bills' THEN RETURN (ARRAY['💡', '🧾', '🏠', '📱'])[1 + floor(random() * 4)::INTEGER];
    WHEN 'Shopping' THEN RETURN (ARRAY['🛍️', '🛒', '👟', '🎁'])[1 + floor(random() * 4)::INTEGER];
    WHEN 'Entertainment' THEN RETURN (ARRAY['🎬', '🎮', '🎵', '🎟️'])[1 + floor(random() * 4)::INTEGER];
    WHEN 'Salary' THEN RETURN (ARRAY['💰', '💵', '🏦', '📥'])[1 + floor(random() * 4)::INTEGER];
    WHEN 'Investments' THEN RETURN (ARRAY['📈', '📊', '💹', '🏛️'])[1 + floor(random() * 4)::INTEGER];
    ELSE RETURN '🏷️';
  END CASE;
END;
$$;

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.users (id, email, name, avatar_url)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data ->> 'name', NEW.raw_user_meta_data ->> 'full_name'),
    NEW.raw_user_meta_data ->> 'avatar_url'
  );

  INSERT INTO public.categories (user_id, name, icon, color)
  SELECT
    NEW.id,
    category_name,
    public.random_default_category_icon(category_name),
    public.random_default_category_color()
  FROM unnest(ARRAY[
    'Food', 'Transportation', 'Bills', 'Shopping',
    'Entertainment', 'Salary', 'Investments'
  ]) AS category_name;

  RETURN NEW;
END;
$$;

REVOKE ALL ON FUNCTION public.random_default_category_color() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.random_default_category_icon(TEXT) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.handle_new_user() FROM PUBLIC;
