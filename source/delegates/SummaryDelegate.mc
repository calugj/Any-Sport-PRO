import Toybox.System;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Application;
import Toybox.ActivityMonitor;
import Toybox.Lang;

public class SummaryDelegate extends WatchUi.BehaviorDelegate {

    private var position;
    private var summary;
    private var MAX_PAGE;
    private var timer;

    public function initialize(mSummary, mPosition) {
        BehaviorDelegate.initialize();

        position = mPosition;
        summary = mSummary;
        if(Toybox.ActivityMonitor.Info has :timeToRecovery) { MAX_PAGE = 3; }
        else{ MAX_PAGE = 2; }

        timer = new Timer.Timer();
        timer.start(method(:callback), 8000, true); // Automatically switch page every 8 seconds
    }

    public function callback() {
        position = position + 1;
        if(position > MAX_PAGE) {position = 1;}
        WatchUi.switchToView(new SummaryView(summary, position), self, WatchUi.SLIDE_UP);
    }
    
    public function onMenu() {
    	return true;
    }
    
    public function onSelect() {
    	var reminder = getPropertyNumber("Reminder", 0) + 1;
        if(reminder < 22) {
            Application.Properties.setValue("Reminder", reminder);
        } if(reminder == 5 || reminder == 10 || reminder == 20) {
            WatchUi.switchToView(new DonationView(), new LapViewDelegate(), WatchUi.SLIDE_RIGHT);  // Push donation reminder. Use LapViewDelegate because no need to create another Delegate for the same function
            return true;
        }
        System.exit();
        return true;
    }
    
    public function onBack() {
    	onSelect();
    	return true;
    }

    public function onNextPage() {
        timer.stop();
        callback();
        return true;
    }

    public function onPreviousPage() {
        timer.stop();
        position = position - 1;
        if(position < 1) {position = MAX_PAGE;}
        WatchUi.switchToView(new SummaryView(summary, position), self, WatchUi.SLIDE_DOWN);
        return true;
    }
    
}