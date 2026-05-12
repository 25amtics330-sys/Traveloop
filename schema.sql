-- ============================================================
-- TRAVELLOOP - Complete Database Schema
-- Generated from wireframes (Screens 1-14)
-- ============================================================

-- ============================================================
-- SCREEN 1 & 2: Login / Registration
-- ============================================================

CREATE TABLE users (
    user_id        SERIAL PRIMARY KEY,
    first_name     VARCHAR(100)        NOT NULL,
    last_name      VARCHAR(100)        NOT NULL,
    email          VARCHAR(255) UNIQUE NOT NULL,
    phone_number   VARCHAR(20),
    city           VARCHAR(100),
    country        VARCHAR(100),
    password_hash  TEXT                NOT NULL,
    profile_photo  TEXT,                              -- URL / file path
    additional_info TEXT,
    role           VARCHAR(20) NOT NULL DEFAULT 'user'  -- 'user' | 'admin'
                       CHECK (role IN ('user', 'admin')),
    created_at     TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at     TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================
-- SCREEN 3 & 8 & 12: Cities (dedicated table for City Search + Admin Popular Cities)
-- ============================================================

CREATE TABLE cities (
    city_id      SERIAL PRIMARY KEY,
    name         VARCHAR(150) NOT NULL,
    country      VARCHAR(100) NOT NULL,
    region       VARCHAR(100),                        -- e.g. "Western Europe"
    description  TEXT,
    cover_image  TEXT,
    latitude     NUMERIC(9, 6),
    longitude    NUMERIC(9, 6),
    is_popular   BOOLEAN DEFAULT FALSE,               -- Admin "Popular Cities" tab
    visit_count  INT     DEFAULT 0,                   -- tracks trending for Admin analytics
    created_at   TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_cities_country    ON cities(country);
CREATE INDEX idx_cities_popular    ON cities(is_popular);
CREATE INDEX idx_cities_name       ON cities(name);

-- ============================================================
-- SCREEN 3: Main Landing Page – Regions / Places
-- ============================================================

CREATE TABLE places (
    place_id    SERIAL PRIMARY KEY,
    name        VARCHAR(200)  NOT NULL,
    city_id     INT REFERENCES cities(city_id) ON DELETE SET NULL,  -- FK to cities table
    city        VARCHAR(100),                         -- denormalized fallback
    country     VARCHAR(100),
    region      VARCHAR(100),                         -- for "Top Regional Selections"
    description TEXT,
    cover_image TEXT,                                 -- banner / card image URL
    is_popular  BOOLEAN DEFAULT FALSE,
    created_at  TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================
-- SCREEN 4: Create a New Trip
-- ============================================================

CREATE TABLE trips (
    trip_id      SERIAL PRIMARY KEY,
    creator_id   INT  NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    title        VARCHAR(255) NOT NULL,
    place_id     INT  REFERENCES places(place_id) ON DELETE SET NULL,
    start_date   DATE NOT NULL,
    end_date     DATE NOT NULL,
    status       VARCHAR(20) NOT NULL DEFAULT 'upcoming'
                     CHECK (status IN ('ongoing', 'upcoming', 'completed')),
    total_budget NUMERIC(12, 2) DEFAULT 0,
    total_spent  NUMERIC(12, 2) DEFAULT 0,
    cover_image  TEXT,
    created_at   TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at   TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT chk_dates CHECK (end_date >= start_date)
);

-- Users participating in a trip (group travel)
CREATE TABLE trip_members (
    member_id  SERIAL PRIMARY KEY,
    trip_id    INT NOT NULL REFERENCES trips(trip_id) ON DELETE CASCADE,
    user_id    INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    joined_at  TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE (trip_id, user_id)
);

-- Multi-city stops per trip (Screen 13: "Rome stop", invoice: "4 cities")
CREATE TABLE trip_stops (
    stop_id     SERIAL PRIMARY KEY,
    trip_id     INT          NOT NULL REFERENCES trips(trip_id) ON DELETE CASCADE,
    city_id     INT          REFERENCES cities(city_id) ON DELETE SET NULL,
    stop_label  VARCHAR(100) NOT NULL,               -- e.g. "Rome stop", "Paris stop"
    stop_order  INT          NOT NULL DEFAULT 1,
    arrival_date  DATE,
    departure_date DATE,
    CONSTRAINT chk_stop_dates CHECK (departure_date IS NULL OR departure_date >= arrival_date)
);

CREATE INDEX idx_stops_trip ON trip_stops(trip_id);

-- Trip invitations / join requests (Screen 4: "+428 Join" button)
CREATE TABLE trip_invitations (
    invitation_id SERIAL PRIMARY KEY,
    trip_id       INT         NOT NULL REFERENCES trips(trip_id) ON DELETE CASCADE,
    invited_by    INT         NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    invited_user  INT         REFERENCES users(user_id) ON DELETE CASCADE,
    invite_email  VARCHAR(255),                       -- invite by email if user not registered yet
    status        VARCHAR(20) NOT NULL DEFAULT 'pending'
                      CHECK (status IN ('pending', 'accepted', 'declined')),
    invited_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    responded_at  TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_invitations_trip ON trip_invitations(trip_id);
CREATE INDEX idx_invitations_user ON trip_invitations(invited_user);


    suggestion_id SERIAL PRIMARY KEY,
    trip_id       INT  NOT NULL REFERENCES trips(trip_id) ON DELETE CASCADE,
    place_id      INT  REFERENCES places(place_id) ON DELETE SET NULL,
    activity_name VARCHAR(255),
    image_url     TEXT,
    notes         TEXT,
    created_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================
-- SCREEN 5: Build Itinerary
-- ============================================================

CREATE TABLE itinerary_sections (
    section_id   SERIAL PRIMARY KEY,
    trip_id      INT          NOT NULL REFERENCES trips(trip_id) ON DELETE CASCADE,
    section_no   INT          NOT NULL,              -- ordering (1, 2, 3 …)
    title        VARCHAR(255) NOT NULL,              -- e.g. "Flight to Paris"
    description  TEXT,
    start_date   DATE,
    end_date     DATE,
    budget       NUMERIC(12, 2) DEFAULT 0,
    created_at   TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT chk_section_dates CHECK (end_date IS NULL OR end_date >= start_date)
);

-- ============================================================
-- SCREEN 9 (Itinerary View): Day-by-day activities + expenses
-- ============================================================

CREATE TABLE itinerary_days (
    day_id     SERIAL PRIMARY KEY,
    trip_id    INT  NOT NULL REFERENCES trips(trip_id) ON DELETE CASCADE,
    day_number INT  NOT NULL,
    day_date   DATE
);

CREATE TABLE itinerary_activities (
    activity_id   SERIAL PRIMARY KEY,
    day_id        INT          NOT NULL REFERENCES itinerary_days(day_id) ON DELETE CASCADE,
    section_id    INT          REFERENCES itinerary_sections(section_id) ON DELETE SET NULL,
    activity_name VARCHAR(255) NOT NULL,
    description   TEXT,
    expense       NUMERIC(12, 2) DEFAULT 0,
    sort_order    INT DEFAULT 0,
    created_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================
-- SCREEN 8: Activity / City Search
-- ============================================================

CREATE TABLE activities (
    activity_id   SERIAL PRIMARY KEY,
    name          VARCHAR(255) NOT NULL,
    place_id      INT REFERENCES places(place_id) ON DELETE SET NULL,
    category      VARCHAR(100),                      -- e.g. 'Paragliding', 'Hiking'
    description   TEXT,
    image_url     TEXT,
    is_popular    BOOLEAN DEFAULT FALSE,
    created_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================
-- SCREEN 11: Packing Checklist
-- ============================================================

CREATE TABLE packing_checklists (
    checklist_id SERIAL PRIMARY KEY,
    trip_id      INT NOT NULL REFERENCES trips(trip_id) ON DELETE CASCADE,
    user_id      INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    created_at   TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE checklist_categories (
    category_id   SERIAL PRIMARY KEY,
    checklist_id  INT          NOT NULL REFERENCES packing_checklists(checklist_id) ON DELETE CASCADE,
    name          VARCHAR(100) NOT NULL,             -- 'Documents', 'Clothing', 'Electronics'
    sort_order    INT DEFAULT 0
);

CREATE TABLE checklist_items (
    item_id     SERIAL PRIMARY KEY,
    category_id INT          NOT NULL REFERENCES checklist_categories(category_id) ON DELETE CASCADE,
    name        VARCHAR(255) NOT NULL,
    is_packed   BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================
-- SCREEN 13: Trip Notes / Journal
-- ============================================================

CREATE TABLE trip_notes (
    note_id    SERIAL PRIMARY KEY,
    trip_id    INT NOT NULL REFERENCES trips(trip_id) ON DELETE CASCADE,
    user_id    INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    day_id     INT REFERENCES itinerary_days(day_id) ON DELETE SET NULL,  -- NULL = general note
    stop_id    INT REFERENCES trip_stops(stop_id) ON DELETE SET NULL,     -- link to city stop
    stop_label VARCHAR(100),                          -- e.g. "Rome stop"
    title      VARCHAR(255) NOT NULL,
    content    TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Multiple attachments per note (Screen 13: paperclip icon)
CREATE TABLE note_attachments (
    attachment_id SERIAL PRIMARY KEY,
    note_id       INT         NOT NULL REFERENCES trip_notes(note_id) ON DELETE CASCADE,
    file_url      TEXT        NOT NULL,
    file_name     VARCHAR(255),
    file_type     VARCHAR(50),                        -- 'image', 'pdf', 'doc', etc.
    uploaded_at   TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================
-- SCREEN 14: Expense Invoice / Billing
-- ============================================================

CREATE TABLE invoices (
    invoice_id     SERIAL PRIMARY KEY,
    trip_id        INT          NOT NULL REFERENCES trips(trip_id) ON DELETE CASCADE,
    invoice_code   VARCHAR(50)  UNIQUE NOT NULL,      -- e.g. INV-xyz-30290
    generated_date DATE         NOT NULL DEFAULT CURRENT_DATE,
    payment_status VARCHAR(20)  NOT NULL DEFAULT 'pending'
                       CHECK (payment_status IN ('pending', 'paid', 'cancelled')),
    subtotal       NUMERIC(12, 2) NOT NULL DEFAULT 0,
    tax_rate       NUMERIC(5, 2)  NOT NULL DEFAULT 0,
    tax_amount     NUMERIC(12, 2) NOT NULL DEFAULT 0,
    discount       NUMERIC(12, 2) NOT NULL DEFAULT 0,
    grand_total    NUMERIC(12, 2) NOT NULL DEFAULT 0,
    created_at     TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE invoice_line_items (
    line_item_id SERIAL PRIMARY KEY,
    invoice_id   INT          NOT NULL REFERENCES invoices(invoice_id) ON DELETE CASCADE,
    line_no      INT          NOT NULL,
    category     VARCHAR(100),                       -- 'hotel', 'travel', etc.
    description  VARCHAR(255) NOT NULL,
    qty_details  VARCHAR(100),                       -- e.g. "3 nights"
    unit_cost    NUMERIC(12, 2) NOT NULL DEFAULT 0,
    amount       NUMERIC(12, 2) NOT NULL DEFAULT 0
);

-- ============================================================
-- SCREEN 10: Community Tab
-- ============================================================

CREATE TABLE community_posts (
    post_id    SERIAL PRIMARY KEY,
    user_id    INT  NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    trip_id    INT  REFERENCES trips(trip_id) ON DELETE SET NULL,
    place_id   INT  REFERENCES places(place_id) ON DELETE SET NULL,
    content    TEXT NOT NULL,
    image_url  TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE community_post_likes (
    like_id    SERIAL PRIMARY KEY,
    post_id    INT NOT NULL REFERENCES community_posts(post_id) ON DELETE CASCADE,
    user_id    INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE (post_id, user_id)
);

CREATE TABLE community_post_comments (
    comment_id SERIAL PRIMARY KEY,
    post_id    INT  NOT NULL REFERENCES community_posts(post_id) ON DELETE CASCADE,
    user_id    INT  NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    content    TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================
-- SCREEN 12: Admin Panel
-- ============================================================

CREATE TABLE admin_analytics_snapshots (
    snapshot_id    SERIAL PRIMARY KEY,
    snapshot_date  DATE    NOT NULL DEFAULT CURRENT_DATE,
    total_users    INT     DEFAULT 0,
    total_trips    INT     DEFAULT 0,
    active_trips   INT     DEFAULT 0,
    top_city_id    INT     REFERENCES places(place_id) ON DELETE SET NULL,
    top_activity_id INT    REFERENCES activities(activity_id) ON DELETE SET NULL,
    notes          TEXT,
    created_at     TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================
-- SUPPORTING: Search / Filter Helpers (Indexes)
-- ============================================================

-- Fast user lookups
CREATE INDEX idx_users_email         ON users(email);

-- Trip queries by user and status
CREATE INDEX idx_trips_creator       ON trips(creator_id);
CREATE INDEX idx_trips_status        ON trips(status);
CREATE INDEX idx_trips_place         ON trips(place_id);

-- Itinerary traversal
CREATE INDEX idx_sections_trip       ON itinerary_sections(trip_id);
CREATE INDEX idx_days_trip           ON itinerary_days(trip_id);
CREATE INDEX idx_activities_day      ON itinerary_activities(day_id);

-- Community feed
CREATE INDEX idx_posts_user          ON community_posts(user_id);
CREATE INDEX idx_posts_place         ON community_posts(place_id);
CREATE INDEX idx_posts_created       ON community_posts(created_at DESC);

-- Checklist
CREATE INDEX idx_checklist_trip      ON packing_checklists(trip_id);

-- Notes
CREATE INDEX idx_notes_trip          ON trip_notes(trip_id);

-- Invoice
CREATE INDEX idx_invoice_trip        ON invoices(trip_id);

-- ============================================================
-- VIEWS (convenience queries matching the UI screens)
-- ============================================================

-- Screen 6: User Trip Listing (ongoing / upcoming / completed)
CREATE VIEW v_user_trips AS
SELECT
    t.trip_id,
    t.creator_id,
    u.first_name || ' ' || u.last_name AS creator_name,
    t.title,
    p.name        AS place_name,
    t.start_date,
    t.end_date,
    t.status,
    t.total_budget,
    t.total_spent,
    t.cover_image
FROM trips t
JOIN users  u ON u.user_id  = t.creator_id
LEFT JOIN places p ON p.place_id = t.place_id;

-- Screen 14: Invoice summary with budget insight
CREATE VIEW v_invoice_summary AS
SELECT
    i.invoice_id,
    i.invoice_code,
    t.title          AS trip_title,
    t.start_date,
    t.end_date,
    t.total_budget,
    i.grand_total    AS total_spent,
    (t.total_budget - i.grand_total) AS remaining,
    i.payment_status,
    i.generated_date
FROM invoices i
JOIN trips t ON t.trip_id = i.trip_id;

-- Screen 11: Packing checklist progress
CREATE VIEW v_checklist_progress AS
SELECT
    pc.checklist_id,
    pc.trip_id,
    cc.name          AS category,
    COUNT(ci.item_id)                              AS total_items,
    COUNT(ci.item_id) FILTER (WHERE ci.is_packed)  AS packed_items
FROM packing_checklists pc
JOIN checklist_categories cc ON cc.checklist_id = pc.checklist_id
JOIN checklist_items      ci ON ci.category_id  = cc.category_id
GROUP BY pc.checklist_id, pc.trip_id, cc.name;

-- ============================================================
-- SAMPLE SEED DATA (for development / testing)
-- ============================================================

INSERT INTO users (first_name, last_name, email, phone_number, city, country, password_hash, role)
VALUES
    ('James',  'Smith',  'james@example.com',  '+1-555-0101', 'New York',  'USA',    'hashed_pw_1', 'user'),
    ('Arjun',  'Mehta',  'arjun@example.com',  '+91-98765',   'Mumbai',    'India',  'hashed_pw_2', 'user'),
    ('Jerry',  'Lee',    'jerry@example.com',  '+44-7911',    'London',    'UK',     'hashed_pw_3', 'user'),
    ('Cristina','Gomez', 'cristina@example.com','+34-600',    'Madrid',    'Spain',  'hashed_pw_4', 'user'),
    ('Admin',  'User',   'admin@travelloop.com','+1-555-0001', 'San Francisco','USA', 'hashed_pw_5', 'admin');

INSERT INTO places (name, city, country, region, description, is_popular)
VALUES
    ('Eiffel Tower',   'Paris',  'France', 'Western Europe', 'Iconic iron lattice tower.',        TRUE),
    ('Colosseum',      'Rome',   'Italy',  'Southern Europe','Ancient amphitheater in Rome.',      TRUE),
    ('Taj Mahal',      'Agra',   'India',  'South Asia',     'UNESCO World Heritage mausoleum.',   TRUE),
    ('Santorini',      'Thira',  'Greece', 'Southern Europe','Volcanic island with white houses.', TRUE),
    ('Bali Temples',   'Ubud',   'Indonesia','Southeast Asia','Spiritual temples in rice paddies.', TRUE);

INSERT INTO trips (creator_id, title, place_id, start_date, end_date, status, total_budget)
VALUES
    (1, 'Trip to Europe Adventure', 1, '2025-05-25', '2026-01-05', 'ongoing',  20000),
    (2, 'Bali Retreat',             5, '2026-06-01', '2026-06-14', 'upcoming', 15000),
    (1, 'Rome Weekend',             2, '2024-09-10', '2024-09-13', 'completed', 5000);

INSERT INTO trip_members (trip_id, user_id) VALUES (1, 2), (1, 3), (1, 4);

INSERT INTO itinerary_sections (trip_id, section_no, title, description, start_date, end_date, budget)
VALUES
    (1, 1, 'Flight DEL → PAR',  'International flight to Paris.',   '2025-05-25', '2025-05-25', 12000),
    (1, 2, 'Hotel – Paris',     '3 nights at Hotel Le Marais.',     '2025-05-25', '2025-05-28',  9000),
    (1, 3, 'Train PAR → ROM',   'High-speed train to Rome.',        '2025-05-28', '2025-05-28',  1000);

INSERT INTO invoices (trip_id, invoice_code, payment_status, subtotal, tax_rate, tax_amount, discount, grand_total)
VALUES (1, 'INV-xyz-30290', 'pending', 21000, 5, 1050, 50, 22000);

INSERT INTO invoice_line_items (invoice_id, line_no, category, description, qty_details, unit_cost, amount)
VALUES
    (1, 1, 'hotel',  'hotel booking paris',          '3 nights', 3000,  9000),
    (1, 2, 'travel', 'flight bookings (DEL -> PAR)', '1',        12000, 12000);

INSERT INTO activities (name, place_id, category, is_popular)
VALUES
    ('Paragliding',      4, 'Adventure',   TRUE),
    ('Wine Tasting',     1, 'Food & Drink', TRUE),
    ('Colosseum Tour',   2, 'Culture',     TRUE),
    ('Temple Hopping',   5, 'Spiritual',   TRUE);

INSERT INTO community_posts (user_id, trip_id, place_id, content)
VALUES
    (1, 1, 1, 'Paris is breathtaking! The Eiffel Tower at sunset is something else.'),
    (2, 2, 5, 'Bali temples are incredibly peaceful. Highly recommend Tirta Empul!'),
    (3, 3, 2, 'The Colosseum exceeded all my expectations. Book tickets in advance!');
