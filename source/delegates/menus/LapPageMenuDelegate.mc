import Toybox.WatchUi;
import Toybox.Lang;

public class LapPageMenuDelegate extends WatchUi.Menu2InputDelegate {
    
    
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function onSelect(item) {
        var startIndex = 0;
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { startIndex--; }

        switch(item.getId()) {
            case :value:
                var lapPage = getPropertyNumber("LapPage", 2);
                var view = new CustomNumberPicker();
                WatchUi.switchToView(view, new LapPageSelector(view, lapPage, 0, 5), WatchUi.SLIDE_LEFT);
                break;
            case :field:
                WatchUi.switchToView(MenuBuilder.fieldsMenu(startIndex), new FieldLapPageMenuDelegate(), WatchUi.SLIDE_LEFT);
                break;
        }
    }


    public function onBack() {
        var menu = MenuBuilder.lapMenu(0);
        var index = menu.findItemById(:lapscreen);
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { index--; }
        menu.setFocus(index);
        WatchUi.switchToView(menu, new LapMenuDelegate(), WatchUi.SLIDE_RIGHT);
        return true;
    }
}