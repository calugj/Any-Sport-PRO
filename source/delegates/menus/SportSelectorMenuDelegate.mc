import Toybox.WatchUi;
import Toybox.Lang;

public class SportSelectorMenuDelegate extends WatchUi.Menu2InputDelegate {
    
    private var id;
    
    public function initialize(mid) {
        Menu2InputDelegate.initialize();

        id = mid;
    }

    public function onSelect(item) {
        var startIndex = 0;
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { startIndex--; }

        if(item.getId() == :edit) {
            WatchUi.switchToView(MenuBuilder.customizeMenu(startIndex), new CustomizeMenuDelegate(), WatchUi.SLIDE_LEFT);
            return;
        }



        var array = item.getId().toCharArray();

        var sport = "";
        var flag = false;
        var subsport = "";
        for(var i = 0 ; i < array.size() ; i++) {
            if(array[i] == '.') {
                flag = true;
                continue;
            }
            
            if(!flag) {
                sport = sport + array[i];
            } else {
                subsport = subsport + array[i];
            }
        }
        
        Application.Properties.setValue("ActivityType", sport.toNumber());
        Application.Properties.setValue("SubSport", subsport.toNumber());
        Application.Properties.setValue("ActivityName", item.getLabel());

        sessionData.createSession();

        var menu = MenuBuilder.mainMenu(0);
        var index = menu.findItemById(:activity);
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { index--; }
        menu.setFocus(index);
        WatchUi.switchToView(menu, new MainMenuDelegate(), WatchUi.SLIDE_RIGHT);
        
    }

    public function onBack() {
        var menu = MenuBuilder.activityCategoryMenu(0);
        var index = menu.findItemById(id);
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { index--; }
        menu.setFocus(index);
        WatchUi.switchToView(menu, new CategoryMenuDelegate(), WatchUi.SLIDE_RIGHT);
        return true;
    }
}