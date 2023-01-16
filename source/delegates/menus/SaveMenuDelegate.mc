import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Attention;

public class SaveMenuDelegate extends WatchUi.Menu2InputDelegate {
    
    private var view;

    public function initialize(mView) {
        Menu2InputDelegate.initialize();

        view = mView;
    }

    public function onSelect(item) {
        switch(item.getId()) {
            case :back:
                WatchUi.popView(WatchUi.SLIDE_BLINK);
                sessionData.start();
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
                break;
            case :save:
                WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
                WatchUi.switchToView(new WatchUi.ProgressBar(WatchUi.loadResource(Rez.Strings.saving), null), new ProgressDelegate(), WatchUi.SLIDE_BLINK);
                if (Attention has :vibrate) {
                    Attention.vibrate([new Attention.VibeProfile(50, 100)]);
                }

                if (Attention has :playTone) {
                    Attention.playTone(Attention.TONE_RESET);
                }
                break;
            case :delete:
                WatchUi.pushView(new WatchUi.Confirmation(WatchUi.loadResource(Rez.Strings.menu_discard)), new DeleteDelegate(), WatchUi.SLIDE_LEFT);
                break;
        }
    }

    public function onBack() {
        WatchUi.popView(WatchUi.SLIDE_BLINK);
    }
}