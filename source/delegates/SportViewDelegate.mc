import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Attention;
import Toybox.Timer;

public class SportViewDelegate extends WatchUi.BehaviorDelegate {

    private var view;
    private var timer;

    public function initialize(mView) {
        BehaviorDelegate.initialize();

        view = mView;
    }

    public function onMenu() as Boolean {
        if(timer != null && sessionData.isStarted()) {
            timer.stop();
            timer = null;
        }
        var index = 0;
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { index--; }
        WatchUi.pushView(MenuBuilder.mainMenu(index), new MainMenuDelegate(), WatchUi.SLIDE_BLINK);
        return true;
    }

    private function pressSelect() as Boolean {
        if (Attention has :vibrate) {
            Attention.vibrate([new Attention.VibeProfile(50, 1000)]);
        }

        if(timer != null) {
                timer.stop();
                timer = null;
            }

        if(!sessionData.isRecording()) {            
            sessionData.start();
            if (Attention has :playTone) {
                Attention.playTone(Attention.TONE_START);
            }
            view.onHide();
            view.setCircleColor(Graphics.COLOR_DK_GREEN);
            view.resetSecondsPast();
            view.onShow();
        } else {
            sessionData.stop();
            if (Attention has :playTone) {
                Attention.playTone(Attention.TONE_STOP);
            }
            view.onHide();
            view.setCircleColor(Graphics.COLOR_RED);
            view.resetSecondsPast();
            view.onShow();

            if(timer == null) {
                timer = new Timer.Timer();
                timer.start(method(:callback), 2000, false);
            }
            
        }

        return true;
    }
    public function callback() {
        if(Toybox.WatchUi has :ActionMenu) {
            WatchUi.showActionMenu(MenuBuilder.saveActionMenu(), new SaveActionMenuDelegate(view));
        } else {
            WatchUi.pushView(MenuBuilder.saveMenu(0), new SaveMenuDelegate(view), WatchUi.SLIDE_BLINK);
        }
    }


    public function pressBack() as Boolean {
        if(sessionData.isRecording() && getPropertyBoolean("lapbutton", true)) {
            
            if(getPropertyNumber("LapPage", 2) >= 1) {
                var lapData = getPropertyNumber("LapData", 1);
                WatchUi.pushView(new LapView(sessionData.getLapData(lapData)), new LapViewDelegate(), WatchUi.SLIDE_BLINK);
            }
            
            sessionData.lap();
            if (Attention has :vibrate) {
                Attention.vibrate([new Attention.VibeProfile(50, 1000)]);
            }

            if (Attention has :playTone) {
                Attention.playTone(Attention.TONE_LAP);
            }

            view.onHide();
            view.setCircleColor(Graphics.COLOR_YELLOW);
            view.resetSecondsPast();
            view.onShow();
        } else if(sessionData.isStarted() && !sessionData.isRecording()) {
            if(timer != null) {
                timer.stop();
                timer = null;
            }
            callback();
        } else if(!sessionData.isRecording()){
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }

        return true;
    }


    private function nextScreen() {
        var numberOfPages = getPropertyNumber("NumberOfPages", 3);
        
        if(numberOfPages == 1) {
            return true;
        }
        var targetPage = view.getPage() + 1;
        if(targetPage > numberOfPages){
            targetPage = 1;
        }
        var vView = new SportView(targetPage);
        sessionData.setView(vView);
        WatchUi.switchToView(vView, new SportViewDelegate(vView), WatchUi.SLIDE_UP);
        return true;
    }
    

    private function previousScreen() {
        var numberOfPages = getPropertyNumber("NumberOfPages", 3);
        
        if(numberOfPages == 1) {
            return true;
        }
        var targetPage = view.getPage() - 1;
        if(targetPage <= 0){
            targetPage = numberOfPages;
        }
        var vView = new SportView(targetPage);
        sessionData.setView(vView);
        WatchUi.switchToView(vView, new SportViewDelegate(vView), WatchUi.SLIDE_DOWN);
        return true;
    }





    public function onTap(clickEvent) {
        view.resetBurnInBacklightCounter();
        
        if(clickEvent.getCoordinates()[1] < System.getDeviceSettings().screenHeight*0.3) {
            onMenu();
        } else {
            view.resetSecondsPast();
        }
        return true;
    }

    public function onSwipe(swipeEvent) {
        view.resetBurnInBacklightCounter();
        
        switch(swipeEvent.getDirection()) {
            case WatchUi.SWIPE_UP:
                nextScreen();
                break;
            case WatchUi.SWIPE_DOWN:
                previousScreen();
                break;
            case WatchUi.SWIPE_RIGHT:
                if(!sessionData.isStarted()) {
                    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
                }
                break;
        }
        return true;
    }

    public function onKey(keyEvent) {
        view.resetBurnInBacklightCounter();

        switch(keyEvent.getKey()) {
            case WatchUi.KEY_ENTER:
                pressSelect();
                break;
            case WatchUi.KEY_ESC:
                pressBack();
                break;
            case WatchUi.KEY_UP:
                if(view.isHintShown()) {
                    onMenu();
                } else {
                    previousScreen();
                }
                break;
            case WatchUi.KEY_DOWN:
                if(view.isHintShown()) {
                    view.onHide();
                    view.resetSecondsPast();
                    view.onShow();
                } else {
                    nextScreen();
                }
                break;
        }
        return true;
    }





    public function onSelect() as Boolean {
        return false;
    }
    public function onBack() as Boolean {
        return false;
    }
    public function onNextPage() as Boolean {
        return false;
    }
    public function onPreviousPage() as Boolean {
        return false;
    }
}