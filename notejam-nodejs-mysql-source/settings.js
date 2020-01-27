var settings = {
    development: {
        db: "notejam",
        dsn: "mysql://" + process.env.MYSQL_USER + ":" + process.env.MYSQL_PASSWORD + "@" + process.env.MYSQL_HOST + ":" + process.env.MYSQL_TCP_PORT + "/notejam"
    },
    test: {
        db: "notejam",
        dsn: "mysql://" + process.env.MYSQL_USER + ":" + process.env.MYSQL_PASSWORD + "@" + process.env.MYSQL_HOST + ":" + process.env.MYSQL_TCP_PORT + "/notejam"
    }
};

var env = process.env.NODE_ENV;

if (!env) {
    env = 'development'
}

module.exports = settings[env];
