var express     = require("express"),
    app         = express(),
    passport    = require('passport'),
    LocalStrategy = require('passport-local'),
    bodyParser  = require("body-parser"),
    mongoose    = require("mongoose"),
    methodOverride = require('method-override'),
    User        = require("./models/user");
    seedDB      = require("./seeds"),
    port        = 3000;

var commentsRoutes      = require('./routes/comments'),
    campgroundsRoutes   = require('./routes/campgrounds'),
    indexRoutes          = require("./routes/index");
    
mongoose.connect("mongodb://localhost/yelp_camp_5", { useNewUrlParser: true });

app.use(methodOverride('_method'));
app.use(bodyParser.urlencoded({extended: true}));
app.set("view engine", "ejs");
app.use(express.static(__dirname + "/public"));
seedDB();


// passport configuration
app.use(require('express-session')({
    secret: 'Yanko the best dog ever was!',
    resave: false,
    saveUninitialized: false
}));
app.set('views', path.join(__dirname, 'views'));
app.use(passport.initialize());
app.use(passport.session());
passport.use(new LocalStrategy(User.authenticate()));
passport.serializeUser(User.serializeUser());
passport.deserializeUser(User.deserializeUser());

app.use(indexRoutes);
app.use('/campgrounds', campgroundsRoutes);
app.use('/campgrounds/:id/comments', commentsRoutes);

module.exports = app;