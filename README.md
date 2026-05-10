# 🌍 Traveloop — Backend Authentication API

> Hackathon project backend built with **Node.js, Express, Supabase (PostgreSQL), and JWT**.

## 🚀 Quick Start

```bash
# 1. Navigate to backend folder
cd backend

# 2. Install dependencies
npm install

# 3. Configure your .env file (see below)

# 4. Start the dev server
npm run dev
```

## ⚙️ Environment Setup

Edit `backend/.env` with your Supabase credentials:

```env
PORT=5000
JWT_SECRET=mysecretkey
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key
```

**Where to get these:**
1. Go to [supabase.com](https://supabase.com) → open your project
2. Click **Project Settings** (⚙️ gear icon) → **API**
3. Copy **Project URL** → paste as `SUPABASE_URL`
4. Copy **anon public key** → paste as `SUPABASE_ANON_KEY`

## 🗄️ Database Setup (for DB teammate)

Go to Supabase Dashboard → **SQL Editor** → run this query:

```sql
CREATE TABLE users (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT,
    email TEXT UNIQUE,
    password TEXT
);
```

> **Important:** Also go to **Authentication → Policies** and make sure Row Level Security (RLS) is either disabled for the `users` table, or add a policy that allows all operations. For a hackathon, the simplest approach is:
>
> ```sql
> ALTER TABLE users DISABLE ROW LEVEL SECURITY;
> ```

## 📡 API Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/` | Health check | ❌ No |
| POST | `/api/auth/register` | Register new user | ❌ No |
| POST | `/api/auth/login` | Login & get JWT token | ❌ No |
| GET | `/api/auth/profile` | Get user profile | ✅ Yes (Bearer token) |

### Register — `POST /api/auth/register`
```json
{
    "name": "Rahul",
    "email": "rahul@example.com",
    "password": "password123"
}
```

### Login — `POST /api/auth/login`
```json
{
    "email": "rahul@example.com",
    "password": "password123"
}
```

### Profile — `GET /api/auth/profile`
```
Header: Authorization: Bearer <your_jwt_token>
```

## 🧪 Testing with Thunder Client / Postman

1. Install **Thunder Client** extension in your IDE
2. Set method to **POST**
3. Enter URL: `http://localhost:5000/api/auth/register`
4. Go to **Body** → select **JSON**
5. Paste the register JSON body from above
6. Click **Send** — you should get a `201` success response
7. Now test Login the same way with `/api/auth/login`
8. Copy the `token` from the login response
9. Test Profile: **GET** `http://localhost:5000/api/auth/profile`
   - Go to **Headers** → add `Authorization: Bearer <paste-token>`
   - Click **Send**

## 🎨 Frontend Integration (for Frontend teammate)

```javascript
// ---- REGISTER ----
const response = await fetch("http://localhost:5000/api/auth/register", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
        name: "Rahul",
        email: "rahul@example.com",
        password: "password123"
    })
});
const data = await response.json();
console.log(data);

// ---- LOGIN ----
const response = await fetch("http://localhost:5000/api/auth/login", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
        email: "rahul@example.com",
        password: "password123"
    })
});
const data = await response.json();
// Save token for future requests
localStorage.setItem("token", data.token);

// ---- PROFILE (protected) ----
const token = localStorage.getItem("token");
const response = await fetch("http://localhost:5000/api/auth/profile", {
    headers: { "Authorization": `Bearer ${token}` }
});
const data = await response.json();
console.log(data.user);
```

## 📂 Project Structure

```
backend/
├── config/
│   └── db.js                 ← Supabase client connection
├── controllers/
│   └── authController.js     ← Register, Login & Profile logic
├── middleware/
│   └── authMiddleware.js     ← JWT token verification
├── routes/
│   └── authRoutes.js         ← API endpoint definitions
├── .env                      ← Supabase credentials (not committed)
├── .gitignore                ← Git ignore rules
├── server.js                 ← Express server entry point
└── package.json              ← Dependencies & scripts
```

## 👥 Team Roles

| Role | Responsibility |
|------|---------------|
| **Backend (You)** | Authentication APIs, JWT, Express server |
| **Frontend** | Login/Register UI pages, API integration |
| **Database** | Supabase project setup, create `users` table, share credentials |
