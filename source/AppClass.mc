import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Position;
import Toybox.System;

public var renderLayout;
public var renderTitles;
public var renderValues;
public var stringGetter;

public var sessionData;


public class AnySportProV3App extends Application.AppBase {

    public function initialize() {
        AppBase.initialize();   
    }

    // onStart() is called on application start up
    public function onStart(state as Dictionary?) as Void {

        var deleteStorage = Application.Storage.getValue("deleteStorage");
        if(deleteStorage == null) {         
            Application.Storage.clearValues();
            Application.Storage.setValue("deleteStorage", true);
        }


        var firstBoot = Application.Storage.getValue("firstBoot");
        if(firstBoot == null) {
            var activityName = getPropertyBoolean("ActivityName", "null");
            if(activityName == null || (activityName instanceof String && activityName.equals("null")) || !(activityName instanceof String)) {
                Application.Properties.setValue("ActivityName", WatchUi.loadResource(Rez.Strings.Running));
            }

            Application.Storage.setValue("firstBoot", false);
        }
        

    }

    // onStop() is called when your application is exiting
    public function onStop(state as Dictionary?) as Void {
    }


    public function getInitialView() as Array<Views or InputDelegates>? {
        return [ new GPSStarter(), new GPSStarterDelegate()] as Array<Views or InputDelegates>;
    }



}

public function getApp() as AnySportProV3App {
    return Application.getApp() as AnySportProV3App;
}



/*
	0 satelliti disattivati
	1 gps
constellation
	2 gps
	3 gps glonass
	4 gps galileo
	5 gps glonass galileo
configuration
	6 gps
	7 gps glonass
	8 gps galileo
	9 gps beidou
	10 gps glonass galileo beidou l1
	11 gps glonass galileo beidou l1 l5
	12 satiq
*/
public function checkSatellitesCompatibility() {
    // use the ConnectIQ 3.3.6 :configuration option
    var supportedSatellites = new[13];
    for(var i = 0 ; i < supportedSatellites.size() ; i++) {
        supportedSatellites[i] = false;
    }
    supportedSatellites[0] = true;

    if (Position has :hasConfigurationSupport) {
        var configurations = [
            Position.CONFIGURATION_GPS,
            Position.CONFIGURATION_GPS_GLONASS,
            Position.CONFIGURATION_GPS_GALILEO,
            Position.CONFIGURATION_GPS_BEIDOU,
            Position.CONFIGURATION_GPS_GLONASS_GALILEO_BEIDOU_L1,
            Position.CONFIGURATION_GPS_GLONASS_GALILEO_BEIDOU_L1_L5,
            Position.CONFIGURATION_SAT_IQ
        ];

        for (var i = 0; i < configurations.size(); ++i) {
            var configuration = configurations[i];
            if (Position.hasConfigurationSupport( configuration )) {
                supportedSatellites[i+6] = true;
            }
        }
    }
    if(Position has :CONSTELLATION_GPS && !(Position has :hasConfigurationSupport)) {
        // use the ConnectIQ 3.2.0 :constellations option
        var constellations = [
            [ Position.CONSTELLATION_GPS ],
            [ Position.CONSTELLATION_GPS, Position.CONSTELLATION_GLONASS ],
            [ Position.CONSTELLATION_GPS, Position.CONSTELLATION_GALILEO ],
            [ Position.CONSTELLATION_GPS, Position.CONSTELLATION_GLONASS, Position.CONSTELLATION_GALILEO ]
        ];

        var options = { :acquisitionType => Position.LOCATION_ONE_SHOT };

        for (var i = 0; i < constellations.size(); ++i) {
            options[:constellations] = constellations[i];

            try {
                Position.enableLocationEvents(options, null);
                supportedSatellites[i+2] = true;
            } catch(e) {
            }
            Position.enableLocationEvents(Position.LOCATION_DISABLE, null);
        }
    }

    // old only gps
    try {
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, null);
        supportedSatellites[1] = true;
    } catch(e) {
    }
    Position.enableLocationEvents(Position.LOCATION_DISABLE, null);



    return supportedSatellites;
}

public function setSatellites(choice) {
    if(choice == 0) {
        Position.enableLocationEvents(Position.LOCATION_DISABLE, null);
        return;
    } else if(choice == 1) {
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, null);
        return;
    }
    
    
    var options = { :acquisitionType => Position.LOCATION_CONTINUOUS };
    if(choice == 2) { options[:constellations] = [Position.CONSTELLATION_GPS]; }
    else if(choice == 3) { options[:constellations] = [Position.CONSTELLATION_GPS, Position.CONSTELLATION_GLONASS]; }
    else if(choice == 4) { options[:constellations] = [Position.CONSTELLATION_GPS, Position.CONSTELLATION_GALILEO]; }
    else if(choice == 5) { options[:constellations] = [Position.CONSTELLATION_GPS, Position.CONSTELLATION_GLONASS, Position.CONSTELLATION_GALILEO]; }
    else if(choice == 6) { options[:configuration] = Position.CONFIGURATION_GPS; }
    else if(choice == 7) { options[:configuration] = Position.CONFIGURATION_GPS_GLONASS; }
    else if(choice == 8) { options[:configuration] = Position.CONFIGURATION_GPS_GALILEO; }
    else if(choice == 9) { options[:configuration] = Position.CONFIGURATION_GPS_BEIDOU; }
    else if(choice == 10) { options[:configuration] = Position.CONFIGURATION_GPS_GLONASS_GALILEO_BEIDOU_L1; }
    else if(choice == 11) { options[:configuration] = Position.CONFIGURATION_GPS_GLONASS_GALILEO_BEIDOU_L1_L5; }
    else if(choice == 12) { options[:configuration] = Position.CONFIGURATION_SAT_IQ; }

    if (Position has :POSITIONING_MODE_AVIATION) {
        options[:mode] = Position.POSITIONING_MODE_AVIATION;
    }

    try{
        Position.enableLocationEvents(options, null);
    } catch(ex) {
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, null);
    }
}

/*
public function migrateMemory() {
    var key =
    [
        "Theme",
        "Satellites",
        "Backlight",
        "Autolap",
        "lapbutton",
        "AutolapValue",
        "PaceUnits500",
        "LapData",
        "LapPage",
        "Autopause",
        "DisableGesture",
        "False",
        "Reminder",
        "ActivityType",
        "SubSport",
        "ActivityName",
        "CustomActivityType1",
        "CustomSubSport1",
        "CustomActivityName1",
        "NumberOfPages",
        "FieldsPage1",
        "FieldsPage2",
        "FieldsPage3",
        "FieldsPage4",
        "11",
        "12",
        "13",
        "14",
        "15",
        "16",
        "21",
        "22",
        "23",
        "24",
        "25",
        "26",
        "31",
        "32",
        "33",
        "34",
        "35",
        "36",
        "41",
        "42",
        "43",
        "44",
        "45",
        "46"
    ];

    var defaults =
    [
        1,
        1,
        0.0,
        false,
        true,
        1.0,
        false,
        1,
        2,
        false,
        false,
        false,
        0,
        1,
        0,
        "null",
        0,
        0,
        "Custom 1",
        3,
        4,
        4,
        3,
        4,
        1,
        3,
        6,
        5,
        11,
        20,
        1,
        3,
        6,
        5,
        11,
        20,
        1,
        3,
        6,
        5,
        11,
        20,
        1,
        3,
        6,
        5,
        11,
        20
    ];

    for(var i = 0 ; i < key.size() ; i++) {
        var value;
        try{
            value = Application.Storage.getValue(key[i]);
        }catch (ex) {
            value = defaults[i];
        }

        if(value == null) {
            value = defaults[i];
        }

        Application.Properties.setValue(key[i], value);
    }

    var activityName;
    try {
        activityName = Application.Properties.getValue("ActivityName");
    } catch(ex) {
        activityName = "null";
    }
    if(activityName == null || (activityName instanceof String && activityName.equals("null")) || !(activityName instanceof String)) {
        Application.Properties.setValue("ActivityName", WatchUi.loadResource(Rez.Strings.Running));
    }

    Application.Storage.clearValues();
    Application.Storage.setValue("hasMigratedMemory", false);
}
*/



public function getPropertyBoolean(key, mDefault) {
    var value = null;
    if (Toybox.Application has :Storage) {
    	try {
    		value = Application.Properties.getValue(key);
    	} catch(ex) {}
    } else {
        value = getApp().getProperty(key);
    }
    if (value == null || !(value instanceof Boolean)) {
        value = mDefault;
    }	
	return value; 
}

public function getPropertyNumber(key, mDefault) {
    var value = null;
    if (Toybox.Application has :Storage) {
    	try {
    		value = Application.Properties.getValue(key);
    	} catch(ex) {}
    } else {
        value = getApp().getProperty(key);
    } 	
    if (value == null) {
        value = mDefault;
    }	
	return value.toNumber(); 
}

public function getPropertyFloat(key, mDefault) {
    var value = null;
    if (Toybox.Application has :Storage) {
    	try {
    		value = Application.Properties.getValue(key);
    	} catch(ex) {}
    } else {
        value = getApp().getProperty(key);
    } 	
    if (value == null) {
        value = mDefault;
    }	
	return value.toFloat(); 
}

public function getPropertyString(key, mDefault) {
    var value = null;
    if (Toybox.Application has :Storage) {
    	try {
    		value = Application.Properties.getValue(key);
    	} catch(ex) {}
    } else {
        value = getApp().getProperty(key);
    } 	
    if (value == null) {
        value = mDefault;
    }	
	return value.toString(); 
}