// ============================================
// AUTH CONTROLLER
// ============================================
// This file contains the actual logic for:
//   1. Registering a new user (signup)
//   2. Logging in an existing user (login)
//   3. Getting the logged-in user's profile
//
// Registration collects: first_name, last_name, username,
//   email, phone, city, country, password
// Login uses: username + password
// ============================================

const bcrypt = require("bcryptjs");       // For hashing passwords securely
const jwt = require("jsonwebtoken");      // For creating login tokens
const supabase = require("../config/db"); // Our Supabase client

// ============================================
// REGISTER (Sign Up) — POST /api/auth/register
// ============================================
// Frontend sends:
//   { first_name, last_name, username, email, phone, city, country, password }
// ============================================

const register = async (req, res) => {
  try {
    // Step 1: Get all user data from the request body
    const { first_name, last_name, username, email, phone, city, country, password } = req.body;

    // Step 2: Validate — make sure required fields are provided
    if (!first_name || !last_name || !username || !email || !password) {
      return res.status(400).json({
        success: false,
        message: "Please provide first_name, last_name, username, email, and password",
      });
    }

    // Step 3: Check if username already exists
    const { data: existingUsername, error: usernameError } = await supabase
      .from("users")
      .select("username")
      .eq("username", username);

    if (usernameError) {
      console.error("❌ Supabase query error:", usernameError.message);
      return res.status(500).json({
        success: false,
        message: "Database error. Please try again.",
      });
    }

    if (existingUsername && existingUsername.length > 0) {
      return res.status(409).json({
        success: false,
        message: "Username is already taken. Please choose a different one.",
      });
    }

    // Step 4: Check if email already exists
    const { data: existingEmail, error: emailError } = await supabase
      .from("users")
      .select("email")
      .eq("email", email);

    if (emailError) {
      console.error("❌ Supabase query error:", emailError.message);
      return res.status(500).json({
        success: false,
        message: "Database error. Please try again.",
      });
    }

    if (existingEmail && existingEmail.length > 0) {
      return res.status(409).json({
        success: false,
        message: "Email is already registered. Please use a different email or login.",
      });
    }

    // Step 5: Hash the password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Step 6: Insert the new user into Supabase
    const { data: newUser, error: insertError } = await supabase
      .from("users")
      .insert([
        {
          first_name: first_name,
          last_name: last_name,
          username: username,
          email: email,
          phone: phone || null,       // Optional field
          city: city || null,         // Optional field
          country: country || null,   // Optional field
          password: hashedPassword,
        },
      ])
      .select("id, first_name, last_name, username, email, phone, city, country")
      .single();

    // Handle insert error
    if (insertError) {
      console.error("❌ Supabase insert error:", insertError.message);
      return res.status(500).json({
        success: false,
        message: "Error creating user. Please try again.",
      });
    }

    // Step 7: Return success response
    res.status(201).json({
      success: true,
      message: "User registered successfully! You can now login.",
      user: newUser,
      // NOTE: Password is NOT included in the response
    });
  } catch (error) {
    console.error("❌ Registration error:", error.message);
    res.status(500).json({
      success: false,
      message: "Server error during registration. Please try again.",
    });
  }
};

// ============================================
// LOGIN — POST /api/auth/login
// ============================================
// Frontend sends: { username, password }
// Backend returns: { success, token, user }
// ============================================

const login = async (req, res) => {
  try {
    // Step 1: Get login data from the request body
    const { username, password } = req.body;

    // Step 2: Validate
    if (!username || !password) {
      return res.status(400).json({
        success: false,
        message: "Please provide both username and password",
      });
    }

    // Step 3: Find the user by username
    const { data: users, error: findError } = await supabase
      .from("users")
      .select("*")
      .eq("username", username);

    // Handle database error
    if (findError) {
      console.error("❌ Supabase query error:", findError.message);
      return res.status(500).json({
        success: false,
        message: "Database error. Please try again.",
      });
    }

    // If no user found with that username
    if (!users || users.length === 0) {
      return res.status(401).json({
        success: false,
        message: "Invalid username or password",
      });
    }

    const user = users[0];

    // Step 4: Compare password with hashed password
    const isPasswordCorrect = await bcrypt.compare(password, user.password);

    if (!isPasswordCorrect) {
      return res.status(401).json({
        success: false,
        message: "Invalid username or password",
      });
    }

    // Step 5: Create JWT token
    const token = jwt.sign(
      {
        id: user.id,
        username: user.username,
        email: user.email,
      },
      process.env.JWT_SECRET,
      { expiresIn: "24h" }
    );

    // Step 6: Return success with token and user data
    res.status(200).json({
      success: true,
      message: "Login successful!",
      token: token,
      user: {
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        username: user.username,
        email: user.email,
        phone: user.phone,
        city: user.city,
        country: user.country,
        // NOTE: Password is NOT included!
      },
    });
  } catch (error) {
    console.error("❌ Login error:", error.message);
    res.status(500).json({
      success: false,
      message: "Server error during login. Please try again.",
    });
  }
};

// ============================================
// GET PROFILE — GET /api/auth/profile
// ============================================
// Protected route — requires JWT token
// ============================================

const getProfile = async (req, res) => {
  try {
    const { data: user, error } = await supabase
      .from("users")
      .select("id, first_name, last_name, username, email, phone, city, country")
      .eq("id", req.user.id)
      .single();

    if (error || !user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    res.status(200).json({
      success: true,
      user: user,
    });
  } catch (error) {
    console.error("❌ Profile error:", error.message);
    res.status(500).json({
      success: false,
      message: "Server error fetching profile. Please try again.",
    });
  }
};

// Export all functions
module.exports = { register, login, getProfile };
