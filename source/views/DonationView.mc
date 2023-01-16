import Toybox.System;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Communications;

public class DonationView extends WatchUi.View {
    
    private var timer = null;
    
    public function initialize() {
        View.initialize();

        // For 3.1
        //Communications.openWebPage("https://www.paypal.me/LucaBoscoloMeneguolo", {}, null);
    }


    // Load your resources here
    public function onLayout(dc) {
    }


    public function onShow() {
    	timer = new Timer.Timer();
   		timer.start(method(:end), 8000, false);
    }
    

    public function onUpdate(dc) {
    	// Call the parent onUpdate function to redraw the layout
    	View.onUpdate(dc);

        if(Toybox.Graphics.Dc has :setAntiAlias) {
            dc.setAntiAlias(true);
        }

        var theme = getPropertyNumber("Theme", 1);
        var foregroundColor;
        var backgroundColor;
        

        if(theme == 0) {
            foregroundColor = Graphics.COLOR_WHITE;
            backgroundColor = Graphics.COLOR_BLACK;
        } else {
            foregroundColor = Graphics.COLOR_BLACK;
            backgroundColor = Graphics.COLOR_WHITE;
        }


        dc.setColor(backgroundColor, backgroundColor);
        dc.clear();
        dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);

        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_TINY, WatchUi.loadResource(Rez.Strings.reminder), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }


    public function onHide() {
    }
    
    
    
    public function end() {
    	timer.stop();
    	System.exit();
    }
    
}


public class DonationDelegate extends WatchUi.BehaviorDelegate {
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
