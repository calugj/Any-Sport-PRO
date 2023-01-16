using Toybox.System;
using Toybox.WatchUi;
using Toybox.Timer;
using Toybox.Application;

public class LapView extends WatchUi.View {
    
    private var timer as Timer.Timer = null;
    private var array = null;
    
    
    public function initialize(mArray) {
        View.initialize();
        array = mArray;
    }


    // Load your resources here
    public function onLayout(dc) {
        
    }


    public function onShow() {
    	var lapPage = getPropertyNumber("LapPage", 2);
        
        timer = new Timer.Timer();
   		timer.start(method(:end), lapPage * 1000, false);
    }
    

    public function onUpdate(dc) {
    	// Call the parent onUpdate function to redraw the layout
    	View.onUpdate(dc);

        if(Toybox.Graphics.Dc has :setAntiAlias) {
            dc.setAntiAlias(true);
        }

        var theme = getPropertyNumber("Theme", 1);
        var lapData = getPropertyNumber("LapData", 1);

        var foregroundColor;
        var backgroundColor;
        var accentColor;
        var textColor;
        if(theme == 0) {
            foregroundColor = Graphics.COLOR_BLACK;
            backgroundColor = Graphics.COLOR_WHITE;
            accentColor = Graphics.COLOR_DK_GREEN;
            textColor = Graphics.COLOR_BLACK;
        } else {
            foregroundColor = Graphics.COLOR_WHITE;
            backgroundColor = Graphics.COLOR_BLACK;
            accentColor = Graphics.COLOR_GREEN;
            textColor = Graphics.COLOR_WHITE;
        }

        dc.setColor(foregroundColor, backgroundColor);
        dc.clear();

        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(dc.getWidth()/10);
        dc.drawCircle(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2);

        dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/3, Graphics.FONT_NUMBER_HOT, array[0], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(dc.getWidth()/2, dc.getHeight()*2/3, Graphics.FONT_NUMBER_HOT, array[1], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(dc.getWidth()/2, dc.getWidth()*0.16, Graphics.FONT_SYSTEM_XTINY, stringGetter.getString(2), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(dc.getWidth()/2, dc.getWidth()*0.84, Graphics.FONT_SYSTEM_XTINY, stringGetter.getString(lapData), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);


    }


    public function onHide() {
    }

    public function end() {
        WatchUi.popView(WatchUi.SLIDE_BLINK);
    }

    
    
}


public class LapViewDelegate extends WatchUi.BehaviorDelegate {
    
    public function initialize() {
        BehaviorDelegate.initialize();
    }
    
    public function onMenu() {
    	return true;
    }
    
    public function onSelect() {
        return true;
    }

    public function onBack() {
        return true;
    }
    
}
