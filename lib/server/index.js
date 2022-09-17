const express = require('express')
const bodyParser = require("body-parser");

const app = express()
const port = 3000

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

let qr = ""

app.get('/qr', (req, res) => {
  res.end(JSON.stringify({qr}))
})

app.post('/qr', (req, res) => {
  let b = req.body
  console.log(b, typeof b)
  qr = b['qr']
  res.end("OK")
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
