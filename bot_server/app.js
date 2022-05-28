const express = require('express');
const app = express()
const port = 3000
const chatbot = require('./routes/chatbot')


// Hello world
app.get('/', (req, res) => {
    res.send('<h1>Hello World</h1>')
})

// Middleware
app.use(express.json())

// Add module routes one by one
app.use('/api/v1/chatbot', chatbot) 




app.listen(port, () => {
    console.log(`Server is listening on port:${port}...`)
})

