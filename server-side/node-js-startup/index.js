const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

const app = express();
const port = 3000;

app.use(bodyParser.json());

mongoose.connect('mongodb+srv://Mannat:9rk4ljNVmM7zmyZb@shop-app.kotw1e5.mongodb.net/?retryWrites=true&w=majority&appName=Shop-app');
const db = mongoose.connection;
db.on('error',(error) => console.error(error));
db.once('open',() => console.log('Connected to Database'));

app.get('/', (req, res) => {
    res.json({ success: true, message: "GET route working fine." });
});

app.post('/', (req,res) => {
    const {name, age, email} = req.body;
    const newUser = new User({name: name, age: age, email: email});
    newUser.save();
    res.json('API is working');
});

app.listen(port, () => {
    console.log(`Server is running on :${port}`);
});


const { Schema, model } = mongoose;
const userSchema = new Schema({
    name: String,
    age: Number,
    email: String
});
const User = model('User', userSchema);