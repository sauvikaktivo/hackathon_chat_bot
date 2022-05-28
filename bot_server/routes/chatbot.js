const express = require('express')
const router = express.Router()
const { requestNext } = require('../controllers/chatbot')

router.route('/').post(requestNext)
 
module.exports = router
