// ============================================
// SUPABASE CONNECTION FILE
// ============================================
// This file creates a Supabase client that lets our
// backend talk to the Supabase PostgreSQL database.
//
// Supabase is a cloud-hosted PostgreSQL database with
// a built-in REST API. We use the @supabase/supabase-js
// library to interact with it easily.
//
// SETUP STEPS (for your database teammate):
//   1. Go to https://supabase.com and create a new project
//   2. Go to Project Settings → API
//   3. Copy "Project URL" → put in .env as SUPABASE_URL
//   4. Copy "anon public" key → put in .env as SUPABASE_ANON_KEY
//   5. Go to SQL Editor and run the table creation query (see README)
// ============================================

const { createClient } = require("@supabase/supabase-js");
const dotenv = require("dotenv");

// Load environment variables from .env file
dotenv.config();

// Get Supabase credentials from .env
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_ANON_KEY;

// Validate that credentials are provided
if (!supabaseUrl || !supabaseKey) {
  console.error("❌ Missing Supabase credentials!");
  console.error("   Please set SUPABASE_URL and SUPABASE_ANON_KEY in your .env file.");
  console.error("   Get them from: Supabase Dashboard → Project Settings → API");
  process.exit(1);
}

// Create the Supabase client
// This client handles all database communication automatically
const supabase = createClient(supabaseUrl, supabaseKey);

console.log("✅ Supabase client initialized successfully!");
console.log(`   🌐 Project URL: ${supabaseUrl}`);

// Export the client so other files can use it
module.exports = supabase;
