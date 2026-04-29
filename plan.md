# Campus Resale Marketplace (Baust CampusTrade) - Development Plan

## Features to Implement

### Phase 1: Authentication ✅
1. **User Registration** - Email/password registration with validation ✅
2. **User Login** - Email/password login with session management ✅
3. **Logout** - End user session ✅

### Phase 2: User Management ✅
4. **Profile Management** - View/edit user profile, avatar upload ✅
5. **Listing Management** - View/delete/edit own listings ✅

### Phase 3: Product Listings
6. **Product Posting** - Create listing (image, title, category, price, description) ✅
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

## Project Structure (Clean Architecture)
```
lib/
├── core/
│   ├── constants/      # Supabase config, env handling
│   ├── theme/          # App theme
│   └── utils/          # Logger, Failure, UseCase base
├── features/
│   ├── auth/           # Authentication
│   │   ├── data/       # Models, Datasources, Repository impl
│   │   ├── domain/     # Entities, Repository interface, UseCases
│   │   └── presentation/  # BLoC, Pages
│   ├── listings/       # Listings & Categories
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── profile/        # Profile Management
│       ├── domain/     # UseCases
│       └── presentation/  # Pages
├── injection_container.dart
└── main.dart
```

---

## Database Schema (Supabase/PostgreSQL)

### Tables

#### `users` ✅
| Column | Type | Constraints |
|--------|------|-------------|
| id | UUID | PRIMARY KEY |
| email | VARCHAR(255) | UNIQUE, NOT NULL |
| name | VARCHAR(100) | NOT NULL |
| phone | VARCHAR(20) | |
| avatar_url | TEXT | |
| created_at | TIMESTAMP | DEFAULT NOW() |
| updated_at | TIMESTAMP | DEFAULT NOW() (auto-update trigger) |

#### `categories` ✅
| Column | Type | Constraints |
|--------|------|-------------|
| id | UUID | PRIMARY KEY |
| name | VARCHAR(100) | UNIQUE, NOT NULL |
| icon | VARCHAR(50) | |
| created_at | TIMESTAMP | DEFAULT NOW() |

#### `listings` ✅
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
| updated_at | TIMESTAMP | DEFAULT NOW() (auto-update trigger) |

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

## Implementation Order & Status

| # | Feature | SQL File | Flutter | Status |
|---|---------|----------|---------|--------|
| 1 | User Registration | `001_user_registration.sql` | `lib/features/auth/` | ✅ Done |
| 2 | User Login | - | `lib/features/auth/` | ✅ Done |
| 3 | Logout | - | `lib/features/auth/` | ✅ Done |
| 4 | Profile Management | - | `lib/features/profile/` | ✅ Done |
| 5 | Listing Management | - | `lib/features/listings/` | ✅ Done |
| 6 | Product Posting | `002_categories_and_listings.sql` | `lib/features/listings/` | ✅ Done |
| 7 | Browse Listings | - | `lib/features/listings/` | ✅ Done |
| 8 | Category Filtering | - | `lib/features/listings/` | ✅ Done |
| 9 | Search | - | `lib/features/listings/` | ✅ Done |
| 10 | Price Filter | - | `lib/features/listings/` | ✅ Done |
| 11 | Buyer-Seller Chat | - | `lib/features/chat/` | Pending |
| 12 | Wishlist | - | `lib/features/wishlist/` | Pending |
| 13 | Report/Block | - | `lib/features/users/` | Pending |

---

## Completed Setup
- ✅ Project structure (Clean Architecture)
- ✅ Dependencies (flutter_bloc, supabase_flutter, get_it, dartz, etc.)
- ✅ Supabase initialization with .env support
- ✅ User Registration (SQL + Flutter)
- ✅ User Login (Flutter)
- ✅ Logout (Flutter)
- ✅ API logging on all auth calls
- ✅ Product Posting (SQL + Flutter + Image Upload)
- ✅ Browse Listings (Grid view of all active listings with pull-to-refresh)
- ✅ Category Filtering (Dropdown in app bar to filter by category)
- ✅ Search (Search bar in app bar with search delegate for title/description)
- ✅ Categories with seed data (Books, Electronics, Furniture, Clothing, etc.)
- ✅ Profile Management (View/edit profile, avatar upload)
- ✅ My Listings (View/delete/edit own listings)
- ✅ Edit Listing functionality (update title, description, price, category, image)

---

## Supabase Setup Required
Before running, ensure in Supabase dashboard:
1. Run migration `002_categories_and_listings.sql`
2. Create storage bucket named `listings` (for listing images)
3. Create storage bucket named `avatars` (for profile pictures)
4. Add RLS policy for public read access to storage buckets
