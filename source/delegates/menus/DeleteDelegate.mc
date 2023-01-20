import Toybox.WatchUi;
import Toybox.System;

public class DeleteDelegate extends WatchUi.ConfirmationDelegate {
    
    public function initialize() {
        ConfirmationDelegate.initialize();
    }

    public function onResponse(response) {
        if (response == WatchUi.CONFIRM_YES) {
            //WatchUi.pushView(new WatchUi.ProgressBar(WatchUi.loadResource(Rez.Strings.deleting), null), new ProgressDelegate(1), WatchUi.SLIDE_BLINK);
            sessionData.discard();
            if(!(Toybox.WatchUi has :ActionMenu)) {
                WatchUi.popView(WatchUi.SLIDE_RIGHT);
            }

            if (Attention has :vibrate) {
                Attention.vibrate([new Attention.VibeProfile(50, 100)]);
            }

            if (Attention has :playTone) {
                Attention.playTone(Attention.TONE_RESET);
            }
        }
    }
}