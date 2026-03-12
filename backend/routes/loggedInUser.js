const express = require('express');

const router = express.Router();


//Displays information tailored according to the logged in user
router.get('/profile', (req, res, next) => {
    res.json({
        user: req.user,
        token: req.headers.authorization ? req.headers.authorization.split(' ')[1] : null
    })
});

module.exports = router;