import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Timer;

public class CustomizeMenuDelegate extends WatchUi.Menu2InputDelegate {
    
    
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function onSelect(item) {
        var startIndex = 0;
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { startIndex--; }

        switch(item.getId()) {
            case :name:
                var activityName1 = getPropertyString("CustomActivityName1", "Custom 1");
                if(Toybox.WatchUi has :TextPicker) {
                    WatchUi.pushView(new WatchUi.TextPicker(activityName1.toString()), new KeyboardListener(self), WatchUi.SLIDE_LEFT);
                }
                break;
            case :sport:
                var activityType1 = getPropertyNumber("CustomActivityType1", 1);
                var view = new CustomNumberPicker();
                WatchUi.switchToView(view, new SportSelector(view, activityType1.toNumber(), 0, 255), WatchUi.SLIDE_LEFT);
                break;
            case :subsport:
                var subSport1 = getPropertyNumber("CustomSubSport1", 0);
                var view1 = new CustomNumberPicker();
                WatchUi.switchToView(view1, new SubSportSelector(view1, subSport1.toNumber(), 0, 255), WatchUi.SLIDE_LEFT);
                break;
        }
    }

    public function onBack() {
        var menu = MenuBuilder.customMenu(0);
        var index = menu.findItemById(:edit);
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { index--; }
        menu.setFocus(index);
        WatchUi.switchToView(menu, new SportSelectorMenuDelegate(:custom), WatchUi.SLIDE_RIGHT);
        return true;
    }





// workaround
    public function update() {
        var timer = new Timer.Timer();
        timer.start(method(:callback), 70, false);
    }

    public function callback() {
        var menu = MenuBuilder.customizeMenu(0);
        var index = menu.findItemById(:name);
        menu.setFocus(index);
        WatchUi.switchToView(menu, self, WatchUi.SLIDE_IMMEDIATE);

    }


}