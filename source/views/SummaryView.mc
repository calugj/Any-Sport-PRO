import Toybox.System;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Application;
import Toybox.ActivityMonitor;
import Toybox.Lang;
import Toybox.Graphics;

// Shown after activity save. Position ranges from 1 to 3 and indicates onUpdate() which info need to be shown.
// This is done to save some code.
public class SummaryView extends WatchUi.View {
    
    private var summary;
    private var position;
    private var showPages;
    private var timer;

    private var theme;
    private var foregroundColor;
    private var backgroundColor;
    private var accentColor;
    
    public function initialize(mSummary, mPosition) {
        View.initialize();

        summary = mSummary; 
        position = mPosition;
        showPages = true;

        theme = 0;
        foregroundColor = 0;
        backgroundColor = 0;
        accentColor = 0;
    }


    // Load your resources here
    public function onLayout(dc) {
        theme = getPropertyNumber("Theme", 1);

        if(theme == 0) {
            foregroundColor = Graphics.COLOR_WHITE;
            backgroundColor = Graphics.COLOR_BLACK;
            accentColor = Graphics.COLOR_DK_GREEN;
        } else {
            foregroundColor = Graphics.COLOR_BLACK;
            backgroundColor = Graphics.COLOR_WHITE;
            accentColor = 0x005500;
        }
    }


    public function onShow() {
        timer = new Timer.Timer();
        timer.start(method(:callback), 1000, false);
    }

    public function callback() {
        showPages = false;
        WatchUi.requestUpdate();
    }
    

    public function onUpdate(dc) {
    	// Call the parent onUpdate function to redraw the layout
    	View.onUpdate(dc);

        if(Toybox.Graphics.Dc has :setAntiAlias) {
            dc.setAntiAlias(true);
        }
        
        dc.setColor(backgroundColor, backgroundColor);
        dc.clear();


        switch(position) {
            case 1: // Time, distance and speed
                var btmpw = WatchUi.loadResource(Rez.Drawables.LauncherIcon).getWidth();
                dc.drawBitmap(dc.getWidth()/2 - btmpw/2, dc.getHeight()/7 - btmpw/4, WatchUi.loadResource(Rez.Drawables.LauncherIcon));
                dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
                dc.drawText(dc.getWidth()/2, dc.getHeight()*0.4, Graphics.FONT_SYSTEM_NUMBER_HOT, summary[1], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
                dc.drawText(dc.getWidth()/2, dc.getHeight()*0.575, Graphics.FONT_SMALL, summary[0], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
                dc.drawText(dc.getWidth()/2, dc.getHeight()*0.7, Graphics.FONT_SMALL, summary[3], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
                break;
            case 2: // Training effect
                var degreeEnd = 225 - 270/5*summary[4].toFloat();
                if(degreeEnd < 0) { degreeEnd = degreeEnd + 360; }
                if(summary[4].toFloat() == 0) { degreeEnd = 224; }

                dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
                dc.drawText(dc.getWidth()/2, dc.getHeight()*1.8/7, Graphics.FONT_TINY, WatchUi.loadResource(Rez.Strings.trainingnEffect), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
                dc.drawText(dc.getWidth()/2, dc.getHeight()*5.5/8, Graphics.FONT_TINY, WatchUi.loadResource(Rez.Strings.aerobic), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
                dc.drawText(dc.getWidth()/2, dc.getHeight()*0.52, Graphics.FONT_NUMBER_HOT, summary[4], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
                
                dc.setColor(accentColor, Graphics.COLOR_TRANSPARENT);
                dc.setPenWidth(dc.getWidth()/20);
                dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getHeight()/2 - dc.getHeight()/55, Graphics.ARC_CLOCKWISE, 225, degreeEnd);
                break;
            case 3: // Recovery hours (if supported by device)
                var recoveryValue = summary[5];
                if(recoveryValue == null) {recoveryValue = 0;}
                dc.setColor(accentColor, Graphics.COLOR_TRANSPARENT);
                dc.drawText(dc.getWidth()/2, dc.getHeight()*0.51, Graphics.FONT_NUMBER_HOT, recoveryValue, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
                dc.drawText(dc.getWidth()/2, dc.getHeight()*5.25/8, Graphics.FONT_XTINY, WatchUi.loadResource(Rez.Strings.hours), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
                dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
                dc.drawText(dc.getWidth()/2, dc.getHeight()*2/7, Graphics.FONT_TINY, WatchUi.loadResource(Rez.Strings.recovery), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
                break;      
        }

        // Draw the select hint only for non-touch devices
        if(!System.getDeviceSettings().isTouchScreen) {
            dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(3);
            dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2 - dc.getWidth()/48, Graphics.ARC_CLOCKWISE, 38, 23);
        }

        if(showPages) {
            renderPageNumber(dc, foregroundColor, backgroundColor);
        }
    }

    // Renders the dots that indicate which page is displayed
    private function renderPageNumber(dc as Graphics.Dc, color as Number, backgroundColor as Number) as Void{
        var numberOfPages = 2;
        if(Toybox.ActivityMonitor.Info has :timeToRecovery) { numberOfPages = 3; }
        
        var offset = dc.getWidth()/23;
        var radius = dc.getWidth()/120;
        
        dc.setPenWidth(radius * 2);
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);

        if(numberOfPages == 2) {
            if(position == 1) {
                dc.fillCircle(offset , dc.getHeight()/2 - offset, radius * 3);
                dc.drawCircle(offset , dc.getHeight()/2 + offset, radius * 2);
            } else if(position == 2) {
                dc.drawCircle(offset , dc.getHeight()/2 - offset, radius * 2);
                dc.fillCircle(offset , dc.getHeight()/2 + offset, radius * 3);
            }
        }
        else if(numberOfPages == 3) {
            if(position == 1) {
                dc.fillCircle(offset + offset/3, dc.getHeight()/2 - offset * 2, radius * 3);
                dc.drawCircle(offset , dc.getHeight()/2, radius * 2);
                dc.drawCircle(offset + offset/3, dc.getHeight()/2 + offset * 2, radius * 2);
            } else if(position == 2) {
                dc.drawCircle(offset + offset/3, dc.getHeight()/2 - offset * 2, radius * 2);
                dc.fillCircle(offset , dc.getHeight()/2, radius * 3);
                dc.drawCircle(offset + offset/3, dc.getHeight()/2 + offset * 2, radius * 2);
            } else if(position == 3) {
                dc.drawCircle(offset + offset/3, dc.getHeight()/2 - offset * 2, radius * 2);
                dc.drawCircle(offset , dc.getHeight()/2, radius * 2);
                dc.fillCircle(offset + offset/3, dc.getHeight()/2 + offset * 2, radius * 3);
            }
        }
    }


    public function onHide() {
        if(timer != null) {
            timer.stop();
        }
    }
    
}