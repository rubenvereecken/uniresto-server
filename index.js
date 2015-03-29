// These two lines automagically make coffeescript work
require('coffee-script');
require('coffee-script/register');
var env = require('node-env-file');


try {
    env(__dirname + '/.env')
} catch (e) {
    console.log(__dirname + '/.env file not found');
}

var server = require('./server');
server.start();
