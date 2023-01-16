import Toybox.WatchUi;
import Toybox.Lang;

public class LapMenuDelegate extends WatchUi.Menu2InputDelegate {
    
    
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function onSelect(item) {
        var startIndex = 0;
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { startIndex--; }

        switch(item.getId()) {
            case :lapbutton:
                Application.Properties.setValue("lapbutton", item.isEnabled());
                break;
            case :autolap:
                WatchUi.switchToView(MenuBuilder.autolapMenu(startIndex), new AutolapMenuDelegate(), WatchUi.SLIDE_LEFT);
                break;
            case :lapscreen:
                WatchUi.switchToView(MenuBuilder.lapPageMenu(startIndex), new LapPageMenuDelegate(), WatchUi.SLIDE_LEFT);
                break;
        }
    }

    public function onBack() {
        var menu = MenuBuilder.mainMenu(0);
        var index = menu.findItemById(:lap);
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { index--; }
        menu.setFocus(index);
        WatchUi.switchToView(menu, new MainMenuDelegate(), WatchUi.SLIDE_RIGHT);
        return true;
    }
}