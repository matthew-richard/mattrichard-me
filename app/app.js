var express = require('express');

var app = express();
var PORT = 8080;

console.log("Serving main page.");
app.get('/', function (req, res) {
  res.sendFile('index.html', { root: __dirname });
})

console.log("Serving extra details at /details.");
app.get('/details', function (req, res) {
  res.sendFile('index.html', { root: __dirname });
})

console.log("Serving assets.");
app.use('/assets/js', express.static('assets/js'));
app.use('/assets/img', express.static('assets/img'));
app.use('/assets/css', express.static('assets/css'));
app.use('/assets/fonts', express.static('assets/fonts'));
app.use('/assets/pdf', express.static('assets/pdf'));

console.log("Listening on port " + PORT + '.');
app.listen(PORT);
