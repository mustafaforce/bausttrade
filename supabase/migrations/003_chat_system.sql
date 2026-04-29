-- 003: Chat System (Idempotent)
-- Creates conversations, messages, reports, blocks tables with buyer/seller names
-- Safe to re-run - uses DO blocks and existence checks

-- ============================================
-- CONVERSATIONS TABLE
-- ============================================
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_tables WHERE tablename = 'conversations') THEN
    CREATE TABLE conversations (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        listing_id UUID NOT NULL REFERENCES listings(id) ON DELETE CASCADE,
        buyer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        buyer_name VARCHAR(100) NOT NULL,
        seller_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        seller_name VARCHAR(100) NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        UNIQUE(listing_id, buyer_id)
    );
  ELSE
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'conversations' AND column_name = 'buyer_name') THEN
      ALTER TABLE conversations ADD COLUMN buyer_name VARCHAR(100) NOT NULL DEFAULT '';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'conversations' AND column_name = 'seller_name') THEN
      ALTER TABLE conversations ADD COLUMN seller_name VARCHAR(100) NOT NULL DEFAULT '';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'conversations' AND column_name = 'updated_at') THEN
      ALTER TABLE conversations ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
    END IF;
  END IF;
END $$;

-- Enable RLS and create policies on conversations
DO $$
BEGIN
  IF EXISTS (SELECT FROM pg_tables WHERE tablename = 'conversations') THEN
    ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
  END IF;
EXCEPTION WHEN undefined_object THEN NULL;
END $$;

-- Create policy "Participants can view conversations" if not exists
DO $$
BEGIN
  CREATE POLICY "Participants can view conversations" ON conversations FOR SELECT USING (auth.uid() = buyer_id OR auth.uid() = seller_id);
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- Create policy "Authenticated users can create conversations" if not exists
DO $$
BEGIN
  CREATE POLICY "Authenticated users can create conversations" ON conversations FOR INSERT WITH CHECK (auth.uid() = buyer_id OR auth.uid() = seller_id);
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- ============================================
-- MESSAGES TABLE
-- ============================================
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_tables WHERE tablename = 'messages') THEN
    CREATE TABLE messages (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
        sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        content TEXT NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    );
  ELSE
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'messages' AND column_name = 'updated_at') THEN
      ALTER TABLE messages ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
    END IF;
  END IF;
END $$;

-- Enable RLS and create policies on messages
DO $$
BEGIN
  IF EXISTS (SELECT FROM pg_tables WHERE tablename = 'messages') THEN
    ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
  END IF;
EXCEPTION WHEN undefined_object THEN NULL;
END $$;

-- Create policy "Participants can view messages" if not exists
DO $$
BEGIN
  CREATE POLICY "Participants can view messages" ON messages FOR SELECT USING (
      EXISTS (
          SELECT 1 FROM conversations
          WHERE conversations.id = messages.conversation_id
          AND (conversations.buyer_id = auth.uid() OR conversations.seller_id = auth.uid())
      )
  );
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- Create policy "Participants can insert messages" if not exists
DO $$
BEGIN
  CREATE POLICY "Participants can insert messages" ON messages FOR INSERT WITH CHECK (
      auth.uid() = sender_id AND
      EXISTS (
          SELECT 1 FROM conversations
          WHERE conversations.id = conversation_id
          AND (conversations.buyer_id = auth.uid() OR conversations.seller_id = auth.uid())
      )
  );
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- Indexes for conversations
CREATE INDEX IF NOT EXISTS idx_conversations_listing ON conversations(listing_id);
CREATE INDEX IF NOT EXISTS idx_conversations_buyer ON conversations(buyer_id);
CREATE INDEX IF NOT EXISTS idx_conversations_seller ON conversations(seller_id);

-- Trigger for conversations updated_at
DROP TRIGGER IF EXISTS update_conversations_updated_at ON conversations;
CREATE TRIGGER update_conversations_updated_at BEFORE UPDATE ON conversations
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Index for messages
CREATE INDEX IF NOT EXISTS idx_messages_conversation ON messages(conversation_id);

-- Trigger for messages updated_at
DROP TRIGGER IF EXISTS update_messages_updated_at ON messages;
CREATE TRIGGER update_messages_updated_at BEFORE UPDATE ON messages
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- REPORTS TABLE
-- ============================================
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_tables WHERE tablename = 'reports') THEN
    CREATE TABLE reports (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        reporter_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        reported_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        reason TEXT,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    );
  END IF;
END $$;

DO $$
BEGIN
  IF EXISTS (SELECT FROM pg_tables WHERE tablename = 'reports') THEN
    ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
  END IF;
EXCEPTION WHEN undefined_object THEN NULL;
END $$;

DO $$
BEGIN
  CREATE POLICY "Users can insert reports" ON reports FOR INSERT WITH CHECK (auth.uid() = reporter_id);
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- ============================================
-- BLOCKS TABLE
-- ============================================
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_tables WHERE tablename = 'blocks') THEN
    CREATE TABLE blocks (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        blocker_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        blocked_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        UNIQUE(blocker_id, blocked_user_id)
    );
  END IF;
END $$;

DO $$
BEGIN
  IF EXISTS (SELECT FROM pg_tables WHERE tablename = 'blocks') THEN
    ALTER TABLE blocks ENABLE ROW LEVEL SECURITY;
  END IF;
EXCEPTION WHEN undefined_object THEN NULL;
END $$;

DO $$
BEGIN
  CREATE POLICY "Users can view own blocks" ON blocks FOR SELECT USING (auth.uid() = blocker_id);
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$
BEGIN
  CREATE POLICY "Users can insert blocks" ON blocks FOR INSERT WITH CHECK (auth.uid() = blocker_id);
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;