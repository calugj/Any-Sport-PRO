import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application;
import Toybox.Position;

public class SatellitesMenuDelegate extends WatchUi.Menu2InputDelegate {
    
    
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function onSelect(item) {
        Application.Properties.setValue("Satellites", item.getId());

        setSatellites(0);
        setSatellites(item.getId());

        onBack();
    }

    public function onBack() {
        var menu = MenuBuilder.mainMenu(0);
        var index = menu.findItemById(:satellites);
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { index--; }
        menu.setFocus(index);
        WatchUi.switchToView(menu, new MainMenuDelegate(), WatchUi.SLIDE_RIGHT);
    }
}