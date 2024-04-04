const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000; // Use the provided PORT environment variable or default to 3000

app.get('/hello', (req, res) => {
    res.send('Hello!');
});

app.get('/bye', (req, res) => {
    res.send('Bye!');
});

app.get('/movie', (req, res) => {
    res.send('lets watch some movie!');
});

app.get('/version', (req, res) => {
    res.send('this is a surprise!');
});


app.get('/greeting', (req, res) => {
    res.send('good morning!');
});

app.get('/', (req, res) => {
    res.send('Welcome to the server');
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
