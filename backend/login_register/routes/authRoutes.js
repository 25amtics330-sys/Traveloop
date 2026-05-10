// ============================================
// AUTH ROUTES
// ============================================
// This file defines the URL endpoints for authentication.
// It connects each URL to the correct controller function.
//
// Routes created:
//   POST /api/auth/register  →  Register a new user
//   POST /api/auth/login     →  Login an existing user
//   GET  /api/auth/profile   →  Get logged-in user's profile (protected)
//
// The frontend teammate will call these URLs from their
// login/register pages using fetch() or axios.
// ============================================

const express = require("express");
const router = express.Router();

// Import the controller functions
const { register, login, getProfile } = require("../controllers/authController");

// Import the auth middleware (protects routes that need login)
const { verifyToken } = require("../middleware/authMiddleware");

// ---- Public Routes (no login required) ----

// Register route: POST /api/auth/register
// Frontend sends: { name, email, password }
// Backend returns: { success, message, user }
router.post("/register", register);

// Login route: POST /api/auth/login
// Frontend sends: { email, password }
// Backend returns: { success, message, token, user }
router.post("/login", login);

// ---- Protected Routes (login required — must send JWT token) ----

// Profile route: GET /api/auth/profile
// Frontend sends: Authorization header with "Bearer <token>"
// Backend returns: { success, user }
router.get("/profile", verifyToken, getProfile);

// Export the router so server.js can use it
module.exports = router;
