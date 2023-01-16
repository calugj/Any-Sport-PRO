import Toybox.Lang;

public class StringGetter {

	//private var array;

    public function initialize() {
		/*
		array = new[37];
		array[0] = "none";
		array[1] = WatchUi.loadResource(Rez.Strings.timer);
		array[2] = WatchUi.loadResource(Rez.Strings.timerLap);
    	array[3] = WatchUi.loadResource(Rez.Strings.distance);
    	array[4] = WatchUi.loadResource(Rez.Strings.distanceLap);
    	array[5] = WatchUi.loadResource(Rez.Strings.heartRate);
    	array[6] = WatchUi.loadResource(Rez.Strings.pace);
    	array[7] = WatchUi.loadResource(Rez.Strings.heading);
    	array[8] = WatchUi.loadResource(Rez.Strings.calories);
    	array[9] = WatchUi.loadResource(Rez.Strings.speed);
    	array[10] = WatchUi.loadResource(Rez.Strings.maxSpeed);
    	array[11] = WatchUi.loadResource(Rez.Strings.maxPace);
    	array[12] = WatchUi.loadResource(Rez.Strings.avgSpeed);
    	array[13] = WatchUi.loadResource(Rez.Strings.avgPace);
    	array[14] = WatchUi.loadResource(Rez.Strings.avgHR);
    	array[15] = WatchUi.loadResource(Rez.Strings.maxHR);
    	array[16] = WatchUi.loadResource(Rez.Strings.caloriez);
    	array[17] = WatchUi.loadResource(Rez.Strings.cadence);
    	array[18] = WatchUi.loadResource(Rez.Strings.avgLapPace);
    	array[19] = WatchUi.loadResource(Rez.Strings.avgLapSpeed);
    	array[20] = WatchUi.loadResource(Rez.Strings.altitude);
    	array[21] = WatchUi.loadResource(Rez.Strings.totalAscent);
    	array[22] = WatchUi.loadResource(Rez.Strings.totalDescent);
    	array[23] = WatchUi.loadResource(Rez.Strings.temperature);
    	array[24] = WatchUi.loadResource(Rez.Strings.windSpeed);
    	array[25] = WatchUi.loadResource(Rez.Strings.feelsLike);
    	array[26] = WatchUi.loadResource(Rez.Strings.windBearing);
    	array[27] = WatchUi.loadResource(Rez.Strings.humidity);
    	array[28] = WatchUi.loadResource(Rez.Strings.lowHigh);
    	array[29] = WatchUi.loadResource(Rez.Strings.ambientPressure);
    	array[30] = WatchUi.loadResource(Rez.Strings.oxygen);
    	array[31] = WatchUi.loadResource(Rez.Strings.time);
    	array[32] = WatchUi.loadResource(Rez.Strings.battery);
    	array[33] = WatchUi.loadResource(Rez.Strings.accuracy);
    	array[34] = WatchUi.loadResource(Rez.Strings.trainingEffect);
    	array[35] = "% " + WatchUi.loadResource(Rez.Strings.maxHR);
    	array[36] = WatchUi.loadResource(Rez.Strings.menu_lap);
    	*/
    }

/*
	public function getString(typeRequired) {
		if(typeRequired < 0 || typeRequired >= array.size()) {return array[0];}
		
		return array[typeRequired];
	}
*/





	
    public function getString(typeRequired)
    {
    	if (typeRequired == 1){
    		return WatchUi.loadResource(Rez.Strings.timer);
    	} else if (typeRequired == 2){
    		return WatchUi.loadResource(Rez.Strings.timerLap);
    	} else if (typeRequired == 3){
    		return WatchUi.loadResource(Rez.Strings.distance);
    	} else if (typeRequired == 4){
    		return WatchUi.loadResource(Rez.Strings.distanceLap);
    	} else if (typeRequired == 5){
    		return WatchUi.loadResource(Rez.Strings.heartRate);
    	} else if (typeRequired == 6){
    		return WatchUi.loadResource(Rez.Strings.pace);
    	} else if (typeRequired == 7){
    		return WatchUi.loadResource(Rez.Strings.heading);
    	} else if (typeRequired == 8){
    		return WatchUi.loadResource(Rez.Strings.calories);
    	} else if (typeRequired == 9){
    		return WatchUi.loadResource(Rez.Strings.speed);
    	} else if (typeRequired == 10){
    		return WatchUi.loadResource(Rez.Strings.maxSpeed);
    	} else if (typeRequired == 11){
    		return WatchUi.loadResource(Rez.Strings.maxPace);
    	} else if (typeRequired == 12){
    		return WatchUi.loadResource(Rez.Strings.avgSpeed);
    	} else if (typeRequired == 13){
    		return WatchUi.loadResource(Rez.Strings.avgPace);
    	} else if (typeRequired == 14){
    		return WatchUi.loadResource(Rez.Strings.avgHR);
    	} else if (typeRequired == 15){
    		return WatchUi.loadResource(Rez.Strings.maxHR);
    	} else if (typeRequired == 16){
    		return WatchUi.loadResource(Rez.Strings.caloriez);
    	} else if(typeRequired == 17){
    		return WatchUi.loadResource(Rez.Strings.cadence);
    	} else if(typeRequired == 18){
    		return WatchUi.loadResource(Rez.Strings.avgLapPace);
    	} else if(typeRequired == 19){
    		return WatchUi.loadResource(Rez.Strings.avgLapSpeed);
    	} else if(typeRequired == 20){
    		return WatchUi.loadResource(Rez.Strings.altitude);
    	} else if(typeRequired == 21){
    		return WatchUi.loadResource(Rez.Strings.totalAscent);
    	} else if(typeRequired == 22){
    		return WatchUi.loadResource(Rez.Strings.totalDescent);
    	} else if(typeRequired == 23){
    		return WatchUi.loadResource(Rez.Strings.temperature);
    	} else if(typeRequired == 24){
    		return WatchUi.loadResource(Rez.Strings.windSpeed);
    	} else if(typeRequired == 25){
    		return WatchUi.loadResource(Rez.Strings.feelsLike);
    	} else if(typeRequired == 26){
    		return WatchUi.loadResource(Rez.Strings.windBearing);
    	} else if(typeRequired == 27){
    		return WatchUi.loadResource(Rez.Strings.humidity);
    	} else if(typeRequired == 28){
    		return WatchUi.loadResource(Rez.Strings.lowHigh);
    	} else if(typeRequired == 29){
    		return WatchUi.loadResource(Rez.Strings.ambientPressure);
    	} else if(typeRequired == 30){
    		return WatchUi.loadResource(Rez.Strings.oxygen);
    	} else if(typeRequired == 31){
    		return WatchUi.loadResource(Rez.Strings.time);
    	} else if(typeRequired == 32){
    		return WatchUi.loadResource(Rez.Strings.battery);
    	} else if(typeRequired == 33){
    		return WatchUi.loadResource(Rez.Strings.accuracy);
    	} else if(typeRequired == 34){
    		return WatchUi.loadResource(Rez.Strings.trainingEffect);
    	} else if(typeRequired == 35){
    		return "% " + WatchUi.loadResource(Rez.Strings.maxHR);
    	} else if(typeRequired == 36){
    		return WatchUi.loadResource(Rez.Strings.menu_lap);
    	}
    	return "none";
    }
	

}