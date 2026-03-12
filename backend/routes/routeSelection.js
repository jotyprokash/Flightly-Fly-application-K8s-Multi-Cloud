var express = require('express');
var router = express.Router();
var bus = require('../models/Buses');


// router.get('/', (req, res) => {
//     bus.find({ companyName, startCity, totalseats, availableseats }, (err, result) => {
//         if (err) res.send(err)
//         else res.json({ result })
//     })
// })

router.post('/', async (req, res) => {
    try {
        if (req.body.bId) {
            const result = await bus.findOne({ _id: req.body.bId });
            return res.json({ bus: result });
        } else {
            const result = await bus.find({
                startCity: req.body.startCity,
                destination: req.body.destination
            });
            return res.json({ bus: result });
        }
    } catch (err) {
        console.error('Route query error:', err);
        return res.status(500).json({ status: false, message: 'Server error' });
    }
})

// router.post('/', (req, res) => {
//     let newBus = new bus(req.body)
//     newBus.save((err, bus) => {
//         if (err) console.log(err)
//         else res.status(201).json(bus)
//     })
// })
















module.exports = router;
