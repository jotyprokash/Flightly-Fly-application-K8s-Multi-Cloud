var express = require('express');
var router = express.Router();
var User = require('../models/User');
var bcrypt = require('bcrypt');
var moment = require('moment');
var bodyParser = require('body-parser');

var jsonParser = bodyParser.json();

router.get('/', (req, res) => {
  res.send("Register Here");
});

router.post('/', jsonParser, async (req, res) => {
  console.log("REGISTER HIT", req.body);

  try {
    const existing = await User.findOne({ email: req.body.email });
    if (existing) {
      return res.status(400).json({ message: "User already exists" });
    }

    const hashPassword = await bcrypt.hash(req.body.password, 10);

    const user = new User({
      name: req.body.name || "Test User",
      email: req.body.email,
      password: hashPassword,
      mobile: req.body.mobile || "0000000000",
      gender: req.body.gender || "NA",
      dob: req.body.dob 
       ? moment(req.body.dob).format('YYYY-MM-DD')
       : null
    });

    await user.save();
    return res.status(201).json({ message: "User registered successfully" });

  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: "Registration failed" });
  }
});

module.exports = router;












