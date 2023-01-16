import Toybox.WatchUi;
import Toybox.Lang;

public class PageSelectorMenuDelegate extends WatchUi.Menu2InputDelegate {
    
    
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function onSelect(item) {
        var startIndex = 0;
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { startIndex--; }

        if(item.getId() == :numberofpages) {
            var view = new CustomNumberPicker();
            var pageNumber = getPropertyNumber("NumberOfPages", 3);
            
            WatchUi.switchToView(view, new PageSelector(view, pageNumber, 1, 4), WatchUi.SLIDE_LEFT);
            return;
        }

        
        WatchUi.switchToView(MenuBuilder.pageMenu(startIndex, item.getId()), new PageMenuDelegate(item.getId()), WatchUi.SLIDE_LEFT);

    }

    public function onBack() {
        var menu = MenuBuilder.mainMenu(0);
        var index = menu.findItemById(:datafields);
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { index--; }
        menu.setFocus(index);
        WatchUi.switchToView(menu, new MainMenuDelegate(), WatchUi.SLIDE_RIGHT);
        return true;
    }
}