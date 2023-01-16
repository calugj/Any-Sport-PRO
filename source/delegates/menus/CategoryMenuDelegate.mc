import Toybox.WatchUi;
import Toybox.Lang;

public class CategoryMenuDelegate extends WatchUi.Menu2InputDelegate {
    
    
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function onSelect(item) {
        var startIndex = 0;
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { startIndex--; }

        switch(item.getId()) {
            case :running:
                WatchUi.switchToView(MenuBuilder.runningMenu(startIndex), new SportSelectorMenuDelegate(item.getId()), WatchUi.SLIDE_LEFT);
                break;
            case :cycling:
                WatchUi.switchToView(MenuBuilder.cyclingMenu(startIndex), new SportSelectorMenuDelegate(item.getId()), WatchUi.SLIDE_LEFT);
                break;
            case :fitnessequipment:
                WatchUi.switchToView(MenuBuilder.fitnessEquipmentMenu(startIndex), new SportSelectorMenuDelegate(item.getId()), WatchUi.SLIDE_LEFT);
                break;
            case :swimming:
                WatchUi.switchToView(MenuBuilder.swimmingMenu(startIndex), new SportSelectorMenuDelegate(item.getId()), WatchUi.SLIDE_LEFT);
                break;
            case :field:
                WatchUi.switchToView(MenuBuilder.fieldMenu(startIndex), new SportSelectorMenuDelegate(item.getId()), WatchUi.SLIDE_LEFT);
                break;
            case :training:
                WatchUi.switchToView(MenuBuilder.trainingMenu(startIndex), new SportSelectorMenuDelegate(item.getId()), WatchUi.SLIDE_LEFT);
                break;
            case :walking:
                WatchUi.switchToView(MenuBuilder.walkingMenu(startIndex), new SportSelectorMenuDelegate(item.getId()), WatchUi.SLIDE_LEFT);
                break;
            case :wintersports:
                WatchUi.switchToView(MenuBuilder.winterSportsMenu(startIndex), new SportSelectorMenuDelegate(item.getId()), WatchUi.SLIDE_LEFT);
                break;
            case :watersports:
                WatchUi.switchToView(MenuBuilder.waterSportsMenu(startIndex), new SportSelectorMenuDelegate(item.getId()), WatchUi.SLIDE_LEFT);
                break;
            case :flying:
                WatchUi.switchToView(MenuBuilder.flyingMenu(startIndex), new SportSelectorMenuDelegate(item.getId()), WatchUi.SLIDE_LEFT);
                break;
            case :motor:
                WatchUi.switchToView(MenuBuilder.motorMenu(startIndex), new SportSelectorMenuDelegate(item.getId()), WatchUi.SLIDE_LEFT);
                break;
            case :rockclimbing:
                WatchUi.switchToView(MenuBuilder.climbingMenu(startIndex), new SportSelectorMenuDelegate(item.getId()), WatchUi.SLIDE_LEFT);
                break;
            case :diving:
                WatchUi.switchToView(MenuBuilder.divingMenu(startIndex), new SportSelectorMenuDelegate(item.getId()), WatchUi.SLIDE_LEFT);
                break;
            case :extra:
                WatchUi.switchToView(MenuBuilder.extraMenu(startIndex), new SportSelectorMenuDelegate(item.getId()), WatchUi.SLIDE_LEFT);
                break;
            case :custom:
                WatchUi.switchToView(MenuBuilder.customMenu(startIndex), new SportSelectorMenuDelegate(item.getId()), WatchUi.SLIDE_LEFT);
                break;
            
        }
    }

    public function onBack() {
        var menu = MenuBuilder.mainMenu(0);
        var index = menu.findItemById(:activity);
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { index--; }
        menu.setFocus(index);
        WatchUi.switchToView(menu, new MainMenuDelegate(), WatchUi.SLIDE_RIGHT);
        return true;
    }
}