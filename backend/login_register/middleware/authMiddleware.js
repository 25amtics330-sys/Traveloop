// ============================================
// AUTH MIDDLEWARE (JWT Verification)
// ============================================
// This middleware protects routes that require login.
// It checks if the request has a valid JWT token.
//
// HOW TO USE:
//   const { verifyToken } = require("./middleware/authMiddleware");
//   router.get("/profile", verifyToken, profileController);
//
// The frontend must send the token in the request header:
//   headers: { "Authorization": "Bearer <token>" }
// ============================================

const jwt = require("jsonwebtoken");

const verifyToken = (req, res, next) => {
  try {
    // Step 1: Get the Authorization header
    const authHeader = req.headers["authorization"];

    // Step 2: Check if the header exists and starts with "Bearer "
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({
        success: false,
        message: "Access denied. No token provided.",
      });
    }

    // Step 3: Extract the token (remove "Bearer " prefix)
    const token = authHeader.split(" ")[1];

    // Step 4: Verify the token using our secret key
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // Step 5: Attach user data to the request object
    // Now any route handler after this can access req.user
    req.user = decoded;

    // Step 6: Move to the next middleware/route handler
    next();
  } catch (error) {
    return res.status(401).json({
      success: false,
      message: "Invalid or expired token. Please login again.",
    });
  }
};

module.exports = { verifyToken };
