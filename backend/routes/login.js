const express = require("express");
const User = require("../models/User");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");

const router = express.Router();

/**
 * POST /login
 * Authenticate user and return JWT
 */
router.post("/login", async (req, res) => {
  const { email, password } = req.body;

  // 1. Validate input
  if (!email || !password) {
    return res.status(400).json({
      message: "Email and password are required",
    });
  }

  try {
    // 2. Find user
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(401).json({
        message: "Invalid email or password",
      });
    }

    // 3. Compare password
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(401).json({
        message: "Invalid email or password",
      });
    }

    // 4. Create token
    const token = jwt.sign(
      {
        id: user._id,
        email: user.email,
      },
      "top_secret", // later move to env
      { expiresIn: "1h" }
    );

    // 5. Respond
    return res.status(200).json({ token });

  } catch (err) {
    console.error("Login error:", err);
    return res.status(500).json({
      message: "Internal server error",
    });
  }
});

module.exports = router;