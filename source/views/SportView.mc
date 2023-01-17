import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.Application;

public class SportView extends WatchUi.View {

    private var values; // Array containing data fields numeric values
    private var titles; // Array containing data fields titles
    private var fieldId; // Array containing data fields identificators


    private var pageNumber; // Which screen is selected
    private var numberOfFields; // Number of fields in screen
    private var theme;
    private var backlight;
    private var disableGesture;

    private var foregroundColor;
    private var backgroundColor;
    private var circleColor;    

    private var timer; // Update timer 1 second

    // Other variables used to time features like the appearing top banner...
    private var disableGestureTimer;
    private var secondsPast;
    private var previousGPSState;
    private var GPSHintFlag;
    private var burnInBacklightCounter;


    


    public function initialize(mPageNumber) {
        View.initialize();
        
        pageNumber = mPageNumber;
        secondsPast = -2;
        circleColor = 0;
        previousGPSState = 0;
        GPSHintFlag = false;
        backlight = false;
        burnInBacklightCounter = 0;
        numberOfFields = 4;

        values = new[6];
        titles = new[6];
        fieldId = new[6];
        timer = new Timer.Timer();
        disableGestureTimer = new Timer.Timer();
    }

    public function onLayout(dc as Dc) as Void {
        updateLayout();
    }

    public function onShow() as Void {
        updateLayout();

        if(timer == null) {
            timer = new Timer.Timer();
        }
        timer.start(method(:refresh), 1000, true);
        refresh();
    }

    public function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);

        if(Toybox.Graphics.Dc has :setAntiAlias) {
            dc.setAntiAlias(true);
        }

        for(var i = 0 ; i < numberOfFields ; i++) {            
            values[i] = sessionData.getData(fieldId[i]);    // Update the numeric values directly from the session data
        }

        // Draw the UI: Layout (green lines and background), Values and Titles
        switch(numberOfFields) {
            case 1:
                renderLayout.oneField(dc);
                renderValues.oneField(dc, values);
                renderTitles.oneField(dc, titles);
                break;
            case 2:
                renderLayout.twoFields(dc);
                renderValues.twoFields(dc, values);
                renderTitles.twoFields(dc, titles);
                break;
            case 3:
                renderLayout.threeFields(dc);
                renderValues.threeFields(dc, values);
                renderTitles.threeFields(dc, titles);
                break;
            case 4:
                renderLayout.fourFields(dc);
                renderValues.fourFields(dc, values);
                renderTitles.fourFields(dc, titles);
                break;
            case 5:
                renderLayout.fiveFields(dc);
                renderValues.fiveFields(dc, values);
                renderTitles.fiveFields(dc, titles);
                break;
            case 6:
                renderLayout.sixFields(dc);
                renderValues.sixFields(dc, values);
                renderTitles.sixFields(dc, titles);
                break;
        }





        if(secondsPast < 0) {
            showPages(dc);
        }
        



        // Show the coloured ring and then make it transparent
        if(circleColor == Graphics.COLOR_DK_GREEN || circleColor == Graphics.COLOR_RED || circleColor == Graphics.COLOR_YELLOW) {
            dc.setColor(circleColor, Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(dc.getWidth()/12);
            dc.drawCircle(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2);
            if(secondsPast > 0) {
                circleColor = 0;
            }
        }
        
        
        // Render the full top banner
        if (secondsPast >= 0 && isHintShown()){
            showHint(dc);
        } else if(secondsPast >= 0 && isGPSHintShown()) { // Render the reduced top banner
            showGPSHint(dc);
        }



    
    }

    public function onHide() as Void {
        if(timer != null) {
            timer.stop();
        }

        resetBurnInBacklightCounter();
    }




    public function updateLayout() as Void {
        resetBurnInBacklightCounter();

        numberOfFields = getPropertyNumber("FieldsPage" + pageNumber.toString(), 4);
        backlight = getPropertyFloat("Backlight", 0.0) == 1.0;
        disableGesture = getPropertyBoolean("DisableGesture", false);

        theme = getPropertyNumber("Theme", 1);
        if(theme == 0) {
            foregroundColor = Graphics.COLOR_WHITE;
            backgroundColor = Graphics.COLOR_BLACK;
        } else {
            foregroundColor = Graphics.COLOR_BLACK;
            backgroundColor = Graphics.COLOR_WHITE;
        }

        var request = pageNumber.toString();
        for(var i = 0 ; i < numberOfFields ; i++) {
            var number = getPropertyNumber(request + (i + 1).toString(), 1);
            titles[i] = stringGetter.getString(number);
            fieldId[i] = number;
        }
    }



    // Timer 1 second
    public function refresh() {
        if(secondsPast < 300) {
            secondsPast++;
        }
        WatchUi.requestUpdate();


        // Backlight always on feature (MIP Screens)
        if(Toybox.System.DeviceSettings has :requiresBurnInProtection && !(System.getDeviceSettings().requiresBurnInProtection) && backlight) {
            try {
                Attention.backlight(true);
            } catch(ex) {}
        }


        // Wrist gesture disable (AMOLED Screens) 
        if(Toybox.System.DeviceSettings has :requiresBurnInProtection && System.getDeviceSettings().requiresBurnInProtection && disableGesture) {
            if(burnInBacklightCounter < 9) {
                try {
                    Attention.backlight(true);
                } catch(ex) {}
                burnInBacklightCounter++;
            } else {
                if(disableGestureTimer != null) {
                    disableGestureTimer.stop();
                }
                Attention.backlight(false);
                try{
                    disableGestureTimer.start(method(:disableGestureTimerCallback), 50, true);
                } catch(ex) {}
            }
        }

        
        if(sessionData.isStarted() && sessionData.getData(33).toNumber() < 3) {
            GPSHintFlag = true;
        }
    }






    public function disableGestureTimerCallback() {
        Attention.backlight(false);
    }

    public function setCircleColor(mColor) {
        circleColor = mColor;
    }

    public function resetSecondsPast() {
        secondsPast = -2;
    }

    public function resetBurnInBacklightCounter() {
        if(disableGestureTimer != null) {
            disableGestureTimer.stop();
        }
        burnInBacklightCounter = 0;
    }

    public function getPage() as Number {
        return pageNumber;
    }

    public function isHintShown() as Boolean {
        return (secondsPast > 0 && !sessionData.isStarted());
    }

    public function isGPSHintShown() as Boolean {
        return (GPSHintFlag && getPropertyNumber("Satellites", 1) != 0 && secondsPast > 0);
    }




    // Show page indicator
    private function showPages(dc) {
        var numberOfPages = getPropertyNumber("NumberOfPages", 3);

        var offset = dc.getWidth()/23;
        var radius = dc.getWidth()/120;
                

        if(numberOfPages == 1) {
            dc.setPenWidth(radius * 8);
            dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);
            dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()*0.46, Graphics.ARC_CLOCKWISE, 185, 175);
            dc.setPenWidth(radius * 2);
            dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);


            dc.fillCircle(offset , dc.getHeight()/2, radius * 3);
        } else if(numberOfPages == 2) {
            dc.setPenWidth(radius * 8);
            dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);
            dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()*0.46, Graphics.ARC_CLOCKWISE, 190, 170);
            dc.setPenWidth(radius * 2);
            dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);

            if(pageNumber == 1) {
                dc.fillCircle(offset , dc.getHeight()/2 - offset, radius * 3);
                dc.drawCircle(offset , dc.getHeight()/2 + offset, radius * 2);
            } else if(pageNumber == 2) {
                dc.drawCircle(offset , dc.getHeight()/2 - offset, radius * 2);
                dc.fillCircle(offset , dc.getHeight()/2 + offset, radius * 3);
            }
        } else if(numberOfPages == 3) {
            dc.setPenWidth(radius * 8);
            dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);
            dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()*0.46, Graphics.ARC_CLOCKWISE, 195, 165);
            dc.setPenWidth(radius * 2);
            dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);


            if(pageNumber == 1) {
                dc.fillCircle(offset + offset/3, dc.getHeight()/2 - offset * 2, radius * 3);
                dc.drawCircle(offset , dc.getHeight()/2, radius * 2);
                dc.drawCircle(offset + offset/3, dc.getHeight()/2 + offset * 2, radius * 2);
            } else if(pageNumber == 2) {
                dc.drawCircle(offset + offset/3, dc.getHeight()/2 - offset * 2, radius * 2);
                dc.fillCircle(offset , dc.getHeight()/2, radius * 3);
                dc.drawCircle(offset + offset/3, dc.getHeight()/2 + offset * 2, radius * 2);
            } else if(pageNumber == 3) {
                dc.drawCircle(offset + offset/3, dc.getHeight()/2 - offset * 2, radius * 2);
                dc.drawCircle(offset , dc.getHeight()/2, radius * 2);
                dc.fillCircle(offset + offset/3, dc.getHeight()/2 + offset * 2, radius * 3);
            }
        } else if(numberOfPages == 4) {
            dc.setPenWidth(radius * 8);
            dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);
            dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()*0.46, Graphics.ARC_CLOCKWISE, 200, 160);
            dc.setPenWidth(radius * 2);
            dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);


            if(pageNumber == 1) {
                dc.fillCircle(offset + offset/3, dc.getHeight()/2 - offset * 3, radius * 3);
                dc.drawCircle(offset , dc.getHeight()/2 - offset, radius * 2);
                dc.drawCircle(offset , dc.getHeight()/2 + offset, radius * 2);
                dc.drawCircle(offset + offset/3, dc.getHeight()/2 + offset * 3, radius * 2);
            } if(pageNumber == 2) {
                dc.drawCircle(offset + offset/3, dc.getHeight()/2 - offset * 3, radius * 2);
                dc.fillCircle(offset , dc.getHeight()/2 - offset, radius * 3);
                dc.drawCircle(offset , dc.getHeight()/2 + offset, radius * 2);
                dc.drawCircle(offset + offset/3, dc.getHeight()/2 + offset * 3, radius * 2);
            } if(pageNumber == 3) {
                dc.drawCircle(offset + offset/3, dc.getHeight()/2 - offset * 3, radius * 2);
                dc.drawCircle(offset , dc.getHeight()/2 - offset, radius * 2);
                dc.fillCircle(offset , dc.getHeight()/2 + offset, radius * 3);
                dc.drawCircle(offset + offset/3, dc.getHeight()/2 + offset * 3, radius * 2);
            } else if(pageNumber == 4) {
                dc.drawCircle(offset + offset/3, dc.getHeight()/2 - offset * 3, radius * 2);
                dc.drawCircle(offset , dc.getHeight()/2 - offset, radius * 2);
                dc.drawCircle(offset , dc.getHeight()/2 + offset, radius * 2);
                dc.fillCircle(offset + offset/3, dc.getHeight()/2 + offset * 3, radius * 3);
            }
        }
    }

    
    // Show full banner
    private function showHint(dc) {
        dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight()*0.3);
        dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, dc.getHeight()*0.3, dc.getWidth(), 1);

        var accuracy = 4;

        // GPS slider
        if(getPropertyNumber("Satellites", 1) != 0) {
            accuracy = sessionData.getData(33).toNumber();
            if(accuracy == 0 || accuracy == 1) {
                dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
                dc.setPenWidth(2);
                dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()*0.47, Graphics.ARC_CLOCKWISE, 123, 50);
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
                dc.setPenWidth(dc.getHeight()/50);
                dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()*0.47, Graphics.ARC_CLOCKWISE, 130, 125);
            } else if(accuracy == 2 || (previousGPSState < 3 && accuracy >= 3)) {
                dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
                dc.setPenWidth(2);
                dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()*0.47, Graphics.ARC_CLOCKWISE, 88, 50);
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
                dc.setPenWidth(dc.getHeight()/50);
                dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()*0.47, Graphics.ARC_CLOCKWISE, 130, 90);
            }  else if(accuracy == 3) {
                dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
                dc.setPenWidth(dc.getHeight()/50);
                dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()*0.47, Graphics.ARC_CLOCKWISE, 130, 50);
            }   else if(accuracy == 4) {
                dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT);
                dc.setPenWidth(dc.getHeight()/50);
                dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()*0.47, Graphics.ARC_CLOCKWISE, 130, 50);
            }
        }
        


        if(GPSHintFlag) {
            GPSHintFlag = false;
            if (Attention has :vibrate) {
                Attention.vibrate([new Attention.VibeProfile(50, 1000)]);
            }
            if (Attention has :playTone) {
                Attention.playTone(Attention.TONE_MSG);
            }
            if(accuracy == 3) {
                dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
            } else if(accuracy == 4) {
                dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT);
            }
            dc.drawText(dc.getWidth()/2, dc.getHeight()*0.12, Graphics.FONT_XTINY, "GPS", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        } else if(secondsPast%2 == 0) {
            //mostra batteria
            dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);
            var battery = sessionData.getData(32);
            dc.drawText(dc.getWidth()/2, dc.getHeight()*0.12, Graphics.FONT_XTINY, battery + "%", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        } else {
            // mostra opzioni
            dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);
            var string;
            if(System.getDeviceSettings().isTouchScreen) {
                string = WatchUi.loadResource(Rez.Strings.MenuHintBACK) + WatchUi.loadResource(Rez.Strings.options);
            } else {
                string = WatchUi.loadResource(Rez.Strings.MenuHintUP) + WatchUi.loadResource(Rez.Strings.options);
            }
            dc.drawText(dc.getWidth()/2, dc.getHeight()*0.12, Graphics.FONT_XTINY, string, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }

        if(getPropertyNumber("Satellites", 1) != 0 && (previousGPSState < 3 && accuracy == 3 || previousGPSState <= 3 && accuracy == 4)) {
            GPSHintFlag = true;
        }


        dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);
        var hr = sessionData.getData(5);
        if(accuracy == 4) {
            if((secondsPast/2).toNumber()%2 == 0) {
                dc.drawText(dc.getWidth()/2, dc.getHeight()*0.23, Graphics.FONT_TINY, WatchUi.loadResource(Rez.Strings.pressStart), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER); 
            }
            else {
                if(hr.equals("---") && secondsPast%2 == 0 || !(hr.equals("---"))) {
                    dc.drawText(dc.getWidth()/2, dc.getHeight()*0.23, Graphics.FONT_TINY, "❤", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
                }
            }
        }
        else if(hr.equals("---") && secondsPast%2 == 0 || !(hr.equals("---"))) {
            dc.drawText(dc.getWidth()/2, dc.getHeight()*0.23, Graphics.FONT_TINY, "❤", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }



        previousGPSState = accuracy;

    }


    // Show reduced banner
    private function showGPSHint(dc) {
        dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight()*0.17);
        dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, dc.getHeight()*0.17, dc.getWidth(), 1);


        var accuracy = 4;

        // GPS slider
        if(getPropertyNumber("Satellites", 1) != 0) {
            accuracy = sessionData.getData(33).toNumber();
            if(accuracy == 0 || accuracy == 1) {
                dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
                dc.setPenWidth(2);
                dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()*0.47, Graphics.ARC_CLOCKWISE, 123, 50);
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
                dc.setPenWidth(dc.getHeight()/50);
                dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()*0.47, Graphics.ARC_CLOCKWISE, 130, 125);
            } else if(accuracy == 2 || (previousGPSState < 3 && accuracy >= 3)) {
                dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
                dc.setPenWidth(2);
                dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()*0.47, Graphics.ARC_CLOCKWISE, 88, 50);
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
                dc.setPenWidth(dc.getHeight()/50);
                dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()*0.47, Graphics.ARC_CLOCKWISE, 130, 90);
            }  else if(accuracy == 3) {
                dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
                dc.setPenWidth(dc.getHeight()/50);
                dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()*0.47, Graphics.ARC_CLOCKWISE, 130, 50);
                dc.drawText(dc.getWidth()/2, dc.getHeight()*0.12, Graphics.FONT_XTINY, "GPS", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
                if (Attention has :vibrate) {
                    Attention.vibrate([new Attention.VibeProfile(50, 1000)]);
                }
                if (Attention has :playTone) {
                    Attention.playTone(Attention.TONE_MSG);
                }
                GPSHintFlag = false;
            }   else if(accuracy == 4) {
                dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT);
                dc.setPenWidth(dc.getHeight()/50);
                dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()*0.47, Graphics.ARC_CLOCKWISE, 130, 50);
                dc.drawText(dc.getWidth()/2, dc.getHeight()*0.12, Graphics.FONT_XTINY, "GPS", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
                if (Attention has :vibrate) {
                    Attention.vibrate([new Attention.VibeProfile(50, 1000)]);
                }
                if (Attention has :playTone) {
                    Attention.playTone(Attention.TONE_MSG);
                }
                GPSHintFlag = false;
            }
        }

        previousGPSState = accuracy;
    }
}
