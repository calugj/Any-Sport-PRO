import Toybox.WatchUi;
import Toybox.Lang;

public class FieldLapPageMenuDelegate extends WatchUi.Menu2InputDelegate {

    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function onSelect(item) {
        Application.Properties.setValue("LapData", item.getId());
        onBack();   
    }

    public function onBack() {
        var menu = MenuBuilder.lapPageMenu(0);
        var index = menu.findItemById(:field);
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { index--; }
        menu.setFocus(index);
        WatchUi.switchToView(menu, new LapPageMenuDelegate(), WatchUi.SLIDE_RIGHT);
        return true;
    }
}