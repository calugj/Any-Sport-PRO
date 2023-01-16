import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Time;

public class ProgressDelegate extends WatchUi.BehaviorDelegate {

    private var timer;

    public function initialize() {
        BehaviorDelegate.initialize();

        timer = new Timer.Timer();
        timer.start(method(:timerCallback), 1000, false);
    }

    public function timerCallback() {
        var summary = sessionData.getSummary();
        sessionData.save();

        WatchUi.switchToView(new SummaryView(summary, 1), new SummaryDelegate(summary, 1), WatchUi.SLIDE_BLINK);
    }

    public function onSelect() {
        return true;
    }
    public function onBack() {
        return true;
    }


}