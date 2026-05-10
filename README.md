# 🌍 Traveloop

A modern, full-stack trip planning application built with **Flutter (Web)** on the frontend and **Node.js, Express, & Supabase** on the backend.

---

## 🚀 How to Run Locally

To run the full application locally on your machine, you need to run **both** the backend server and the frontend application in separate terminal windows.

### 1. Start the Backend Server
The backend handles user authentication and database connections.

1. Open a terminal and navigate to the backend folder:
   ```bash
   cd backend/login_register
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Make sure your `.env` file is set up with your Supabase credentials (see Environment Setup below).
4. Start the server:
   ```bash
   npm run dev
   ```
   *The backend will now be running on `http://localhost:5000`*

### 2. Start the Frontend (Flutter Web)
The frontend is the beautiful user interface where users log in and view their trips.

1. Open a **new, separate terminal** and navigate to the frontend folder:
   ```bash
   cd Frontend/webapp
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app in Chrome:
   ```bash
   flutter run -d chrome
   ```
   *A Google Chrome window will pop up showing the Traveloop app.*

### 3. (Optional) Quick Web Tester
If you don't want to run the full Flutter app, you can use the built-in HTML web tester.
While the backend is running, just open your browser and go to:
👉 `http://localhost:5000/test`

---

## 🌐 How to Make It Online (Deployment)

To share this with the world, you need to host the database, the backend, and the frontend. 

### 1. Database: Supabase
Your database is already hosted online at Supabase! No extra steps needed here.

### 2. Backend Deployment (Render or Railway)
Your Node.js API must be hosted so your frontend can communicate with it over the internet.
**Recommended: Render.com**
1. Create a free account on [Render](https://render.com/).
2. Connect your GitHub repository.
3. Click **New +** -> **Web Service**.
4. Select your Traveloop repository.
5. Set the **Root Directory** to `backend/login_register`
6. Set the Build Command to `npm install` and Start Command to `node server.js`.
7. Add your Environment Variables (`PORT`, `JWT_SECRET`, `SUPABASE_URL`, `SUPABASE_ANON_KEY`).
8. Click **Deploy**. Render will give you a live URL (e.g., `https://traveloop-api.onrender.com`).

### 3. Frontend Deployment (Vercel or Firebase)
Once your backend is online, you need to update the `baseUrl` in your Flutter code and deploy it.
1. In `Frontend/webapp/lib/Pages/Authorization/auth_page.dart`, change `baseUrl = 'http://localhost:5000/api/auth'` to your new Render backend URL.
2. Open a terminal in your frontend folder and build the web version:
   ```bash
   flutter build web
   ```
3. This creates a highly optimized `build/web/` folder.
4. **Deploy to Vercel:** Go to [Vercel](https://vercel.com/), create a new project, select your repo, set the Framework Preset to "Other", and set the output directory to `Frontend/webapp/build/web`.
5. Your app is now live!

---

## ⚙️ Environment Setup (.env)

Edit `backend/login_register/.env` with your Supabase credentials:

```env
PORT=5000
JWT_SECRET=mysecretkey
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key
```

## 🗄️ Database Schema

The app expects a `users` table in your Supabase SQL Editor:

```sql
CREATE TABLE users (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    username TEXT UNIQUE,
    email TEXT UNIQUE,
    phone TEXT,
    city TEXT,
    country TEXT,
    password TEXT
);
```
