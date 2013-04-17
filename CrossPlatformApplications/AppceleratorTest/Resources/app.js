
// Bootstrap and check dependencies
if (Ti.version < 1.8 ) {
	alert('Sorry - this application template requires Titanium Mobile SDK 1.8 or later'); 
} else {
	//require and open top level UI component
	//var ApplicationWindow = require('ui/ApplicationWindow');
	//new ApplicationWindow().open();
	
}

// Create the web view in index.html
var webView = Ti.UI.createWebView({
        // Hides the title bar on Android devices:
        navBarHidden:true,
	    scalesPageToFit:true,
        backgroundColor : '#F5FFFA',
        // For Android only:
        enableZoomControls : false, 
        url : '/HTML/index.html'
});

var appWin = Titanium.UI.createWindow({fullscreen: true, navBarHidden:true, orientationModes:[Ti.UI.PORTRAIT ] });
appWin.add(webView);
appWin.open();

var accelerometerCallback = function(e) {
  Ti.App.fireEvent('data', { data : e.x +" "+ e.y } );
};

// Adds a listener to the accelerometer
Ti.Accelerometer.addEventListener('update', accelerometerCallback);





