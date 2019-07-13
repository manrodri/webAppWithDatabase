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
    
databeseUrl = process.env.DATABASE_URL
// "mongodb://10.10.11.117/yelp_camp_5"
mongoose.connect(databeseUrl, { useNewUrlParser: true });

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
app.use(passport.initialize());
app.use(passport.session());
passport.use(new LocalStrategy(User.authenticate()));
passport.serializeUser(User.serializeUser());
passport.deserializeUser(User.deserializeUser());

app.use(indexRoutes);
app.use('/campgrounds', campgroundsRoutes);
app.use('/campgrounds/:id/comments', commentsRoutes);

app.listen(port, function(){
    console.log("The YelpCamp Server Has Started!");
 });