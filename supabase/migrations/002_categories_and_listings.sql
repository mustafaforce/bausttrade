-- 002: Categories and Listings + Storage Buckets
-- Creates categories and listings tables for product posting
-- Also creates storage buckets for images

-- Categories table
CREATE TABLE IF NOT EXISTS categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL,
    icon VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security on categories
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can view categories
CREATE POLICY "Anyone can view categories" ON categories
    FOR SELECT USING (true);

-- Listings table
CREATE TABLE IF NOT EXISTS listings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    image_url TEXT,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security on listings
ALTER TABLE listings ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can view active listings
CREATE POLICY "Anyone can view active listings" ON listings
    FOR SELECT USING (status = 'active');

-- Policy: Users can insert their own listings
CREATE POLICY "Users can insert own listings" ON listings
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Policy: Users can update their own listings
CREATE POLICY "Users can update own listings" ON listings
    FOR UPDATE USING (auth.uid() = user_id);

-- Policy: Users can delete their own listings
CREATE POLICY "Users can delete own listings" ON listings
    FOR DELETE USING (auth.uid() = user_id);

-- Index for faster category filtering
CREATE INDEX IF NOT EXISTS idx_listings_category ON listings(category_id);

-- Index for faster user listings lookup
CREATE INDEX IF NOT EXISTS idx_listings_user ON listings(user_id);

-- Index for status filtering
CREATE INDEX IF NOT EXISTS idx_listings_status ON listings(status);

-- Trigger to auto-update updated_at on listings
CREATE TRIGGER update_listings_updated_at
    BEFORE UPDATE ON listings
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Seed default categories
INSERT INTO categories (name, icon) VALUES
    ('Books', 'menu_book'),
    ('Electronics', 'devices'),
    ('Furniture', 'chair'),
    ('Clothing', 'checkroom'),
    ('Accessories', 'backpack'),
    ('Stationery', 'edit'),
    ('Sports', 'sports_soccer'),
    ('Others', 'more_horiz')
ON CONFLICT (name) DO NOTHING;

-- ============================================
-- STORAGE BUCKETS (for images)
-- ============================================

-- Insert storage buckets
INSERT INTO storage.buckets (id, name, public)
VALUES ('listings', 'listings', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policies for listings bucket
CREATE POLICY "Anyone can view listings images"
ON storage.objects FOR SELECT
USING (bucket_id = 'listings');

CREATE POLICY "Authenticated users can upload listings images"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'listings' AND auth.role() = 'authenticated');

CREATE POLICY "Users can update own listings images"
ON storage.objects FOR UPDATE
USING (bucket_id = 'listings' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can delete own listings images"
ON storage.objects FOR DELETE
USING (bucket_id = 'listings' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Storage policies for avatars bucket
CREATE POLICY "Anyone can view avatars images"
ON storage.objects FOR SELECT
USING (bucket_id = 'avatars');

CREATE POLICY "Authenticated users can upload avatars images"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'avatars' AND auth.role() = 'authenticated');

CREATE POLICY "Users can update own avatar image"
ON storage.objects FOR UPDATE
USING (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can delete own avatar image"
ON storage.objects FOR DELETE
USING (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);
