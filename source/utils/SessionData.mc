import Toybox.ActivityRecording;
import Toybox.Activity;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Application;
import Toybox.Timer;
import Toybox.UserProfile;
import Toybox.Lang;

// Manages everything about the session
public class SessionData {

    private var session;
    private var myActivityInfo;
	private var view;	// View currently showed

    private var lastLapDistance;
	private var lapTimer;
    private var lapDistance;
    private var lastLapTime;
    private var lapCount;
	private var isStartedFlag;
	private var pace500;
	private var autopauseEnabled;
	private var autolapEnabled;
	private var excludeAutoPause;

	private var timer;	// For refresh

	

    public function initialize() {
        session = null;

		lastLapDistance = 0;
		lapTimer = 0;
    	lapDistance = 0;
   		lastLapTime = 0;
		lapCount = 1;
        myActivityInfo = Activity.getActivityInfo();

		pace500 = false;
		excludeAutoPause = 6;
		autopauseEnabled = false;
		autolapEnabled = false;


		isStartedFlag = false;

		timer = new Timer.Timer();
		timer.start(method(:updateInfo), 1000, true);

		createSession();
		updateSettings();
		//updateInfo();
    }


	public function updateSettings() {
		pace500 = getPropertyBoolean("PaceUnits500", false);
		autopauseEnabled = getPropertyBoolean("Autopause", false);
		autolapEnabled = getPropertyBoolean("Autolap", false);
	}


	
    public function createSession() as Void {
		session = null;
		var activityType = getPropertyNumber("ActivityType", 1);
		var activityName = getPropertyString("ActivityName", "null");
		var activitySub = getPropertyNumber("SubSport", 0);

		if(activityType instanceof Number && activityName instanceof String && activitySub instanceof Number) {
			session = ActivityRecording.createSession({ :sport => activityType, :name => activityName, :subSport => activitySub });
		} else {
			session = ActivityRecording.createSession({ :sport => 0, :name => "error", :subSport => 0 });
		}
	}

	public function start() {
		session.start();

		isStartedFlag = true;
		excludeAutoPause = 20;
	}

	public function stop() {
		session.stop();

		excludeAutoPause = 20;
	}

	public function discard() as Void{
		session.discard();
		timer.stop();
		self.initialize();
	}

	public function save() as Void {
		session.save();
		timer.stop();
	}

	public function lap() as Void {
		session.addLap();
		lapCount++;
		var info = Activity.getActivityInfo();
		if(info != null) {
			var distance = info.elapsedDistance;
			var timer = info.timerTime;
			if(distance != null && timer != null) {
				lastLapTime = timer - lapTimer;
				lastLapDistance = distance - lapDistance;
				lapTimer = timer;
				lapDistance = distance;
			}
		}     
	}

	public function isRecording() as Boolean {
		return session.isRecording();
	}

	public function isStarted() as Boolean {
		return isStartedFlag;
	}

	// Must set a view each time you change it
	public function setView(mView) {
		view = mView;
	}



	// Updates every second to show real time data
    public function updateInfo() as Void {
        myActivityInfo = Activity.getActivityInfo();
		
		if(autopauseEnabled && isStarted() && excludeAutoPause > 0) {
			excludeAutoPause--;
		} else if(autopauseEnabled && isRecording() && isStarted() && myActivityInfo != null && myActivityInfo.currentSpeed != null && myActivityInfo.currentSpeed <= 0 && excludeAutoPause <= 0) {
			session.stop();
			excludeAutoPause = 6;

			if (Attention has :vibrate) {
				Attention.vibrate([new Attention.VibeProfile(50, 1000)]);
			}
			if (Attention has :playTone) {
                Attention.playTone(Attention.TONE_STOP);
            }

			view.onHide();
			view.setCircleColor(Graphics.COLOR_RED);
			view.resetSecondsPast();
			view.onShow();
		} else if(autopauseEnabled && !isRecording() && isStarted() && myActivityInfo != null && myActivityInfo.currentSpeed != null && myActivityInfo.currentSpeed > 0 && excludeAutoPause <= 0) {
			session.start();
			excludeAutoPause = 6;

			if (Attention has :vibrate) {
				Attention.vibrate([new Attention.VibeProfile(50, 1000)]);
			}
			if (Attention has :playTone) {
                Attention.playTone(Attention.TONE_START);
            }

			view.onHide();
			view.setCircleColor(Graphics.COLOR_DK_GREEN);
			view.resetSecondsPast();
			view.onShow();
		}


		if(autolapEnabled && myActivityInfo != null && myActivityInfo.elapsedDistance != null){
			var currentLapDistance = myActivityInfo.elapsedDistance - lapDistance;
			
			var activityType;
			if(Activity has :getProfileInfo) {
				activityType = Activity.getProfileInfo();
				if(activityType != null && activityType has :sport) {
					activityType = activityType.sport;
				}
			}
				
			if(activityType != null && activityType == ActivityRecording.SPORT_SAILING || activityType == ActivityRecording.SPORT_BOATING || activityType == ActivityRecording.SPORT_WINDSURFING || activityType == ActivityRecording.SPORT_WAKEBOARDING || activityType == ActivityRecording.SPORT_KITESURFING){
				currentLapDistance = currentLapDistance/1852d ;
			} else if(System.getDeviceSettings().distanceUnits == System.UNIT_STATUTE) {    		
    			currentLapDistance = currentLapDistance/1609.34d ;
    		} else {
				currentLapDistance = currentLapDistance/1000d ;
			}
			var targetDistance = getPropertyFloat("AutolapValue", 1.0);

			if(autolapEnabled && targetDistance > 0 && currentLapDistance >= targetDistance) {				
				if(view != null) {
					if (Attention has :vibrate) {
						Attention.vibrate([new Attention.VibeProfile(50, 1000)]);
					}

					if (Attention has :playTone) {
						Attention.playTone(Attention.TONE_LAP);
					}
        			
					view.resetBurnInBacklightCounter();
					view.onHide();
					view.setCircleColor(Graphics.COLOR_YELLOW);
					view.resetSecondsPast();
					view.onShow();

					if(getPropertyNumber("LapPage", 2) >= 1) {
						var lapData = getPropertyNumber("LapData", 1);
						WatchUi.pushView(new LapView(getLapData(lapData)), new LapViewDelegate(), WatchUi.SLIDE_BLINK);
					}
				}

				lap();
			}
		}
		
    }

	





	public function getLapData(typeRequired) {
		var array = new[2];
		array[0] = getData(2);
		array[1] = getData(typeRequired);
		return array;
	}
    
	public function getSummary() {
		var array = new [10];

		var unitDistance = " km";
		var unitSpeed = " km/h";
		var unitPace = " min:km";
		if(System.getDeviceSettings().distanceUnits == System.UNIT_STATUTE) {unitDistance = " mi"; unitSpeed = " mph";}
		if(System.getDeviceSettings().paceUnits == System.UNIT_STATUTE) {unitPace = " min:mi";}
		
		array[0] = getData(3) + unitDistance;	// Distance
		array[1] = getData(1);	// Timer
		array[2] = getData(13) + unitPace;	// AVG Pace
		array[3] = getData(12) + unitSpeed;	// AVG Speed
		var te = myActivityInfo.trainingEffect;
		if(te == null) {te = 0;}
		array[4] = te.format("%.1f");	// T.E.

		if(Toybox.ActivityMonitor.Info has :timeToRecovery) {
			array[5] = ActivityMonitor.getInfo().timeToRecovery;	// Time to Recovery
		}

		return array;
	}












    
    public function getData(typeRequired) {

    	if(myActivityInfo == null){
    		return "--";
    	}
		
		
		if (typeRequired == 1) {
    		return function_timer(myActivityInfo.timerTime, false);
    	} else if (typeRequired == 2) {
    		return function_timer(myActivityInfo.timerTime, true);
    	} else if (typeRequired == 3) {
    		return function_distance(myActivityInfo.elapsedDistance, false);
    	} else if (typeRequired == 4) {
    		return function_distance(myActivityInfo.elapsedDistance, true);
    	} else if (typeRequired == 5) {
    		return function_heart_rate_format(myActivityInfo.currentHeartRate);
    	} else if (typeRequired == 6) {
    		return function_pace_format(myActivityInfo.currentSpeed);
    	} else if (typeRequired == 7) {
    		var heading = myActivityInfo.currentHeading;
    		if(heading == null){return "--";}
    		else if(heading < 0){
    			return function_print_format( (2 * Math.PI + heading) * (180 / Math.PI), "%.0f", false ) ;}
    		return function_print_format( (heading * 180) / Math.PI, "%.0f", false);
    	} else if (typeRequired == 8) {
    		return function_print_format(myActivityInfo.energyExpenditure, "%.0f", false);
    	} else if (typeRequired == 9) {
    		return function_speed_format(myActivityInfo.currentSpeed);
    	} else if (typeRequired == 10) {
    		return function_speed_format(myActivityInfo.maxSpeed);
    	} else if (typeRequired == 11) {
    		return function_pace_format(myActivityInfo.maxSpeed);
    	} else if (typeRequired == 12) {
    		return function_speed_format(myActivityInfo.averageSpeed);
    	} else if (typeRequired == 13) {
    		return function_pace_format(myActivityInfo.averageSpeed);
    	} else if (typeRequired == 14) {
    		return function_heart_rate_format(myActivityInfo.averageHeartRate);
    	} else if (typeRequired == 15) {
    		return function_heart_rate_format(myActivityInfo.maxHeartRate);
    	} else if (typeRequired == 16) {
    		return function_print_format(myActivityInfo.calories, "%.0f", false);
    	} else if(typeRequired == 17) {
    		return function_print_format(myActivityInfo.currentCadence, "%.0f", false);
    	} else if(typeRequired == 18) {
    		var elapsedDistance = 0;
    		if(myActivityInfo.timerTime == null || myActivityInfo.timerTime/1000 - lapTimer/1000 == 0){return "--:--";}
    		if(myActivityInfo.elapsedDistance != null){elapsedDistance = myActivityInfo.elapsedDistance;}
    		return function_pace_format((elapsedDistance - lapDistance) / (myActivityInfo.timerTime/1000 - lapTimer/1000));
    	} else if(typeRequired == 19) {
			var elapsedDistance = 0;
			if(myActivityInfo.timerTime == null || myActivityInfo.timerTime/1000 - lapTimer/1000 ==  0){return "0.0";}
    		if(myActivityInfo.elapsedDistance != null){elapsedDistance = myActivityInfo.elapsedDistance;}
    		return function_speed_format((elapsedDistance - lapDistance) / (myActivityInfo.timerTime/1000 - lapTimer/1000));
    	} else if(typeRequired == 20) {
    		return function_print_format(myActivityInfo.altitude, "%.0f", true);
    	} else if(typeRequired == 21) {
    		return function_print_format(myActivityInfo.totalAscent, "%.0f", true);
    	} else if(typeRequired == 22) {
    		return function_print_format(myActivityInfo.totalDescent, "%.0f", true);
    	} else if(typeRequired == 23) {
    		var weather = Weather.getCurrentConditions();
    		if(weather == null) {
    			return "--";
    		}
    		return function_print_format(weather.temperature, "%.0f", false);
    	} else if(typeRequired == 24) {
			var weather = Weather.getCurrentConditions();
    		if(weather == null) {
    			return "--";
    		}
    		return function_print_format(weather.windSpeed, "%.0f", false);
    	} else if(typeRequired == 25) {
    		var weather = Weather.getCurrentConditions();
    		if(weather == null) {
    			return "--";
    		}
    		return function_print_format(weather.feelsLikeTemperature, "%.0f", false);
    	} else if(typeRequired == 26) {
    		var weather = Weather.getCurrentConditions();
    		if(weather == null) {
    			return "--";
    		}
    		return function_print_format(weather.windBearing, "%.0f", false);
    	} else if(typeRequired == 27) {
    		var weather = Weather.getCurrentConditions();
    		if(weather == null) {
    			return "--";
    		}
    		return function_print_format(weather.relativeHumidity, "%.0f", false);
    	} else if(typeRequired == 28) {
    		var weather = Weather.getCurrentConditions();
    		if(weather == null) {
    			return "--";
    		}
    		return function_print_format(weather.lowTemperature, "%.0f", false) + "/" + function_print_format(weather.highTemperature, "%.0f", false);
    	} else if(typeRequired == 29) {
    		if(myActivityInfo.ambientPressure == null) {
    			return "--";
    		}
    		return function_print_format((myActivityInfo.ambientPressure / 100.0).toNumber(), "%.0f", false);
    	} else if(typeRequired == 30) {
    		return function_print_format(myActivityInfo.currentOxygenSaturation, "%.0f", false) + " %";
    	} else if(typeRequired == 31) {
    		var myTime = System.getClockTime(); // ClockTime object
			return myTime.hour.format("%02d") + ":" + myTime.min.format("%02d");
		} else if(typeRequired == 32) {
			var stats = System.getSystemStats();
			var battery = null;
			if(stats != null){battery = stats.battery;}
			if(battery == null){return "--";}
    		return battery.toNumber().toString();
    	} else if(typeRequired == 33) {
    		var position = Position.getInfo();
    		if(position == null || position.accuracy == null) {return "0";}
    		return position.accuracy.toString();
    	} else if(typeRequired == 34){
			return function_print_format(myActivityInfo.trainingEffect, "%.1f", false);
		}
		else if(typeRequired == 35){
			var genericZoneInfo = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);
			var heartRate = myActivityInfo.currentHeartRate;
			if(heartRate == null) {heartRate = 0;}
			if(genericZoneInfo[5] == null) {genericZoneInfo[5] = 1;}
			var percent = heartRate*100/genericZoneInfo[5];
			return function_print_format(percent, "%.0f", false) + " %";
		} else if(typeRequired == 36){
			return function_print_format(lapCount, "%.0u", false);
		}
    	return "0";
    }




    private function function_timer(timerTime, lapMode) {
        if(timerTime == null) {
            return "0:00";
        }
    	if(lapMode) {
    		timerTime = timerTime - lapTimer;
    	}
        if(timerTime < 0) {
            timerTime = 0;
        }
    	return function_time_format(timerTime);
    }

    private function function_time_format(timerTime) {
        if(timerTime == 0) {
            return "0:00";
        }
        var timerSeconds = timerTime/1000;
    	var timerMinutes = timerSeconds/60;
    	var timerHours = timerMinutes/60;
    	var timerSecondsNormalized = timerSeconds - (timerMinutes * 60);
    	var timerMinutesNormalized = timerMinutes - (timerHours * 60);
    	if(timerMinutesNormalized < 10 && timerHours >= 1) {
    		timerMinutesNormalized = "0" + timerMinutesNormalized.toString();
    	}
        if(timerSecondsNormalized < 10) {
    		timerSecondsNormalized = "0" + timerSecondsNormalized.toString();
    	}
    	
    	//print the values
    	if (timerHours < 1) {
    		return (timerMinutesNormalized + ":" + timerSecondsNormalized);
    	}
    	return(timerHours.toString() + ":" + timerMinutesNormalized + ":" + timerSecondsNormalized);
    }

    private function function_distance(elapsedDistance, lapMode) {
        var activityType;
		if(Activity has :getProfileInfo) {
			activityType = Activity.getProfileInfo();
			if(activityType != null && activityType has :sport) {
				activityType = activityType.sport;
			}
		}
		
		if(elapsedDistance == null) {
    		return("0.00");
    	}

    	if(lapMode) {
    	    elapsedDistance = elapsedDistance - lapDistance;
        }

    	if(elapsedDistance < 0) {
            elapsedDistance = 0;
        }

		if(activityType != null && activityType == ActivityRecording.SPORT_SAILING || activityType == ActivityRecording.SPORT_BOATING || activityType == ActivityRecording.SPORT_WINDSURFING || activityType == ActivityRecording.SPORT_WAKEBOARDING || activityType == ActivityRecording.SPORT_KITESURFING){
			return (elapsedDistance/1852.0f).format("%.2f").toString();	// NM
		} if(System.getDeviceSettings().distanceUnits == System.UNIT_STATUTE) {    		
    		return (elapsedDistance/1609.34d).format("%.2f").toString();
    	}
		return (elapsedDistance/1000.0d).format("%.2f").toString();
    }
/*
    private function function_pace(currentSpeed, info, averageLapMode, averageLastLapMode) {
    	if(averageLapMode) {
            
        }
        if(averageLastLapMode) {
            var elapsedDistance = lastLapDistance;
            var timerTime = lastLapTime;
            if(elapsedDistance == null || timerTime == null || elapsedDistance <= 0 || timerTime <= 0) {
                return "--:--";
            }
            currentSpeed = elapsedDistance/(timerTime/1000d);
        }
        
		return function_pace_format(currentSpeed);
    }
*/
    private function function_pace_format(currentSpeed) {
        if(currentSpeed == null || currentSpeed < 0.83) {
    		return "--:--";
    	}

		if(pace500) {
			currentSpeed = currentSpeed * 2;
		}

        if(System.getDeviceSettings().paceUnits == System.UNIT_STATUTE) {
    		currentSpeed = 60/(currentSpeed*2.23694);
    	} else {
    		currentSpeed = 60.0/(currentSpeed*3.6);
    	}
		
        var paceMin = Math.floor(currentSpeed);
        var paceSec = (currentSpeed-paceMin)*60;
      	paceSec = paceSec.toNumber();
       	if(paceSec < 10) {
        	paceSec = "0" + paceSec.toString();
        }
        return(paceMin.toNumber().toString() + ":" + paceSec);
    }

    private function function_speed_format(currentSpeed) {
        if(currentSpeed == null) {
    		return "0.0";
    	}

		var activityType;
		if(Activity has :getProfileInfo) {
			activityType = Activity.getProfileInfo();
			if(activityType != null && activityType has :sport) {
				activityType = activityType.sport;
			}
		}

		if(activityType != null && activityType == ActivityRecording.SPORT_SAILING || activityType == ActivityRecording.SPORT_BOATING || activityType == ActivityRecording.SPORT_WINDSURFING || activityType == ActivityRecording.SPORT_WAKEBOARDING || activityType == ActivityRecording.SPORT_KITESURFING){
			return (currentSpeed * 1.94384).format("%.1f").toString();	// knots
		} if(System.getDeviceSettings().paceUnits == System.UNIT_STATUTE) {
    		return (currentSpeed * 2.23694).format("%.1f").toString();
    	}
    	return (currentSpeed * 3.6).format("%.1f").toString();
    }

    private function function_heart_rate_format(heartRate) {
    	if(heartRate == null || heartRate == 0) {
    		heartRate = "---";
    	}
    	return heartRate.toString();
    }

    private function function_print_format(toPrint, format, distanceConversion) {
        if(toPrint == null) {
            return "--";
        }
        if(distanceConversion) {
            if(System.getDeviceSettings().distanceUnits == System.UNIT_STATUTE) {
                toPrint = toPrint * 3.28084d;
            }
        }
        return toPrint.format(format).toString();
    }


}