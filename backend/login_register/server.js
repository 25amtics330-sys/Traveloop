// ============================================
// TRAVELOOP — BACKEND SERVER (Entry Point)
// ============================================
// This is the main file that starts your Express server.
// Run it with:  npm run dev  (uses nodemon, auto-restarts)
// Or:           npm start    (uses plain node)
// ============================================

// ---- Step 1: Load Environment Variables ----
// This MUST be the first thing we do, before importing anything else
// It reads values from the .env file and makes them available via process.env
const dotenv = require("dotenv");
dotenv.config();

// ---- Step 2: Import Dependencies ----
const express = require("express");
const cors = require("cors");
const path = require("path");

// ---- Step 3: Import Our Files ----
const authRoutes = require("./routes/authRoutes");
// Note: importing db.js here triggers the Supabase client initialization
require("./config/db");

// ---- Step 4: Create Express App ----
const app = express();

// ---- Step 5: Apply Middleware ----

// CORS — Allows the frontend (running on a different port) to call our API
// Without this, the browser will block requests from the frontend
app.use(
  cors({
    origin: "*", // Allow all origins (fine for hackathon; restrict in production)
    methods: ["GET", "POST", "PUT", "DELETE"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);

// JSON Parser — Allows the server to read JSON data from request bodies
// Without this, req.body would be undefined
app.use(express.json());

// URL-Encoded Parser — Allows the server to read form data
app.use(express.urlencoded({ extended: true }));

// ---- Step 6: Define Routes ----

// Health check route — visit http://localhost:5000/ to verify server is running
app.get("/", (req, res) => {
  res.json({
    message: "🌍 Traveloop API is running!",
    version: "1.0.0",
    database: "Supabase (PostgreSQL)",
    endpoints: {
      register: "POST /api/auth/register",
      login: "POST /api/auth/login",
      profile: "GET  /api/auth/profile (requires token)",
    },
  });
});

// Auth routes — all auth endpoints are prefixed with /api/auth
// So the full URLs become:
//   POST http://localhost:5000/api/auth/register
//   POST http://localhost:5000/api/auth/login
//   GET  http://localhost:5000/api/auth/profile
app.use("/api/auth", authRoutes);

// Test page route — visit http://localhost:5000/test to test APIs in browser
app.get("/test", (req, res) => {
  res.sendFile(path.join(__dirname, "../../test.html"));
});

// ---- Step 7: Start the Server ----
const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log("");
  console.log("============================================");
  console.log("  🌍 TRAVELOOP BACKEND SERVER");
  console.log("============================================");
  console.log(`  🚀 Server running on: http://localhost:${PORT}`);
  console.log(`  📡 Auth API base:     http://localhost:${PORT}/api/auth`);
  console.log(`  🗄️  Database:          Supabase (PostgreSQL)`);
  console.log("============================================");
  console.log("");
});

// Keep process alive
setInterval(() => {}, 10000);
