import Toybox.WatchUi;
import Toybox.Lang;

public class AutolapMenuDelegate extends WatchUi.Menu2InputDelegate {
    
    
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function onSelect(item) {
        var startIndex = 0;
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { startIndex--; }

        switch(item.getId()) {
            case :active:
                Application.Properties.setValue("Autolap", item.isEnabled());
                sessionData.updateSettings();
                WatchUi.switchToView(MenuBuilder.autolapMenu(startIndex), self, WatchUi.SLIDE_IMMEDIATE);
                break;
            case :value:
                var autolapValue = getPropertyFloat("AutolapValue", 1.0) * 100; // 100 = 1.0 km
                var view = new CustomNumberPicker();
                WatchUi.switchToView(view, new AutoLapSelector(view, autolapValue.toNumber(), 1, 500), WatchUi.SLIDE_LEFT);
                break;
        }
    }

    public function onBack() {
        var menu = MenuBuilder.lapMenu(0);
        var index = menu.findItemById(:autolap);
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { index--; }
        menu.setFocus(index);
        WatchUi.switchToView(menu, new LapMenuDelegate(), WatchUi.SLIDE_RIGHT);
        return true;
    }
}