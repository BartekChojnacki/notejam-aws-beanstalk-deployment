var mysql = require('mysql');

var db;
db = mysql.createConnection({
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PASSWORD,
});

db.connect(function(err) {
    if (err) throw err;
    console.log("Connected!");
});

db.query("CREATE DATABASE IF NOT EXISTS notejam;", function (err, result) {
    if (err) throw err;
    console.log("Database Created!");
});

db.query("CREATE TABLE IF NOT EXISTS notejam.users (id INT PRIMARY KEY AUTO_INCREMENT NOT NULL, email VARCHAR(75) NOT NULL, password VARCHAR(128) NOT NULL);", function (err, result) {
    if (err) throw err;
    console.log("Table users Created!");
});

db.query("CREATE TABLE IF NOT EXISTS notejam.pads (id INT PRIMARY KEY AUTO_INCREMENT NOT NULL, name VARCHAR(100) NOT NULL, user_id INTEGER NOT NULL REFERENCES users(id));", function (err, result) {
    if (err) throw err;
    console.log("Table pads Created!");
});

db.query("CREATE TABLE IF NOT EXISTS notejam.notes (id INT PRIMARY KEY AUTO_INCREMENT NOT NULL, pad_id INT REFERENCES notejam.pads(id), user_id INT NOT NULL REFERENCES notejam.users(id), name VARCHAR(100) NOT NULL, text text NOT NULL, created_at TIMESTAMP NOT NULL DEFAULT NOW(), updated_at TIMESTAMP NOT NULL DEFAULT NOW() ON UPDATE NOW());", function (err, result) {
    if (err) throw err;
    console.log("Table notes Created!");
}); 

db.end(function(err) {
  if (err) {
    return console.log('error:' + err.message);
  }
  console.log('Close the database connection.');
});
