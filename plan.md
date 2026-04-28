# Campus Resale Marketplace (Baust CampusTrade) - Development Plan

## Features to Implement

### Phase 1: Authentication
1. **User Registration** - Email/password registration with validation
2. **User Login** - Email/password login with session management
3. **Logout** - End user session

### Phase 2: User Management
4. **Profile Management** - View/edit user profile
5. **Listing Management** - View/edit/delete own listings

### Phase 3: Product Listings
6. **Product Posting** - Create listing (image, title, category, price, description)
7. **Product Listing Browsing** - View all listings
8. **Category-Based Filtering** - Filter by category
9. **Search Functionality** - Search by keyword
10. **Price-Based Filtering** - Filter by price range

### Phase 4: Communication & Safety
11. **Buyer-Seller Chat** - In-app messaging between users
12. **Wishlist** - Save products to wishlist
13. **Report/Block User** - Report or block users

### Phase 5: Future (Post-MVP)
- In-App Payment
- Rating & Review System
- Web Version
- Multiple University Support
- Wishlist Sharing

---

## Tech Stack
- Framework: Flutter
- Language: Dart
- Backend & Database: Supabase
- Design: Figma
- Platform: Android

---

## Database Schema (Supabase/PostgreSQL)

### Tables

#### `users`
| Column | Type | Constraints |
|--------|------|-------------|
| id | UUID | PRIMARY KEY |
| email | VARCHAR(255) | UNIQUE, NOT NULL |
| password_hash | VARCHAR(255) | NOT NULL |
| name | VARCHAR(100) | NOT NULL |
| phone | VARCHAR(20) | |
| avatar_url | TEXT | |
| created_at | TIMESTAMP | DEFAULT NOW() |
| updated_at | TIMESTAMP | DEFAULT NOW() |

#### `categories`
| Column | Type | Constraints |
|--------|------|-------------|
| id | UUID | PRIMARY KEY |
| name | VARCHAR(100) | UNIQUE, NOT NULL |
| icon | VARCHAR(50) | |
| created_at | TIMESTAMP | DEFAULT NOW() |

#### `listings`
| Column | Type | Constraints |
|--------|------|-------------|
| id | UUID | PRIMARY KEY |
| user_id | UUID | FOREIGN KEY → users |
| category_id | UUID | FOREIGN KEY → categories |
| title | VARCHAR(200) | NOT NULL |
| description | TEXT | |
| price | DECIMAL(10,2) | NOT NULL |
| image_url | TEXT | |
| status | VARCHAR(20) | DEFAULT 'active' |
| created_at | TIMESTAMP | DEFAULT NOW() |
| updated_at | TIMESTAMP | DEFAULT NOW() |

#### `wishlists`
| Column | Type | Constraints |
|--------|------|-------------|
| id | UUID | PRIMARY KEY |
| user_id | UUID | FOREIGN KEY → users |
| listing_id | UUID | FOREIGN KEY → listings |
| created_at | TIMESTAMP | DEFAULT NOW() |
| | | UNIQUE(user_id, listing_id) |

#### `conversations`
| Column | Type | Constraints |
|--------|------|-------------|
| id | UUID | PRIMARY KEY |
| listing_id | UUID | FOREIGN KEY → listings |
| buyer_id | UUID | FOREIGN KEY → users |
| seller_id | UUID | FOREIGN KEY → users |
| created_at | TIMESTAMP | DEFAULT NOW() |
| | | UNIQUE(listing_id, buyer_id) |

#### `messages`
| Column | Type | Constraints |
|--------|------|-------------|
| id | UUID | PRIMARY KEY |
| conversation_id | UUID | FOREIGN KEY → conversations |
| sender_id | UUID | FOREIGN KEY → users |
| content | TEXT | NOT NULL |
| created_at | TIMESTAMP | DEFAULT NOW() |

#### `reports`
| Column | Type | Constraints |
|--------|------|-------------|
| id | UUID | PRIMARY KEY |
| reporter_id | UUID | FOREIGN KEY → users |
| reported_user_id | UUID | FOREIGN KEY → users |
| reason | TEXT | |
| created_at | TIMESTAMP | DEFAULT NOW() |

#### `blocks`
| Column | Type | Constraints |
|--------|------|-------------|
| id | UUID | PRIMARY KEY |
| blocker_id | UUID | FOREIGN KEY → users |
| blocked_user_id | UUID | FOREIGN KEY → users |
| created_at | TIMESTAMP | DEFAULT NOW() |
| | | UNIQUE(blocker_id, blocked_user_id) |

---

## Implementation Order

| # | Feature | SQL File | Flutter Files |
|---|---------|----------|---------------|
| 1 | User Registration | `001_user_registration.sql` | `lib/features/auth/` |
| 2 | User Login | `002_user_login.sql` | `lib/features/auth/` |
| 3 | Logout | - | `lib/features/auth/` |
| 4 | Profile Management | - | `lib/features/profile/` |
| 5 | Listing Management | - | `lib/features/listings/` |
| 6 | Product Posting | `006_product_posting.sql` | `lib/features/listings/` |
| 7 | Browse Listings | `007_browse_listings.sql` | `lib/features/listings/` |
| 8 | Category Filtering | `008_category_filtering.sql` | `lib/features/categories/` |
| 9 | Search | `009_search.sql` | `lib/features/search/` |
| 10 | Price Filter | `010_price_filter.sql` | `lib/features/listings/` |
| 11 | Buyer-Seller Chat | `011_chat.sql` | `lib/features/chat/` |
| 12 | Wishlist | `012_wishlist.sql` | `lib/features/wishlist/` |
| 13 | Report/Block | `013_report_block.sql` | `lib/features/users/` |

---

## Feature Status

| # | Feature | Status |
|---|---------|--------|
| 1 | User Registration | Pending |
| 2 | User Login | Pending |
| 3 | Logout | Pending |
| 4 | Profile Management | Pending |
| 5 | Listing Management | Pending |
| 6 | Product Posting | Pending |
| 7 | Browse Listings | Pending |
| 8 | Category Filtering | Pending |
| 9 | Search | Pending |
| 10 | Price Filter | Pending |
| 11 | Buyer-Seller Chat | Pending |
| 12 | Wishlist | Pending |
| 13 | Report/Block | Pending |
