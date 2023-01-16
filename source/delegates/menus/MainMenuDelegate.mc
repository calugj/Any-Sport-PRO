import Toybox.WatchUi;
import Toybox.Lang;

public class MainMenuDelegate extends WatchUi.Menu2InputDelegate {
    
    
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function onSelect(item) {
        var startIndex = 0;
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { startIndex--; }

        switch(item.getId()) {
            case :activity:
                if (!sessionData.isStarted()) {
                    WatchUi.switchToView(MenuBuilder.activityCategoryMenu(startIndex), new CategoryMenuDelegate(), WatchUi.SLIDE_LEFT);
                }
                break;
            case :datafields:
                WatchUi.switchToView(MenuBuilder.pageSelectorMenu(startIndex), new PageSelectorMenuDelegate(), WatchUi.SLIDE_LEFT);
                break;
            case :satellites:
                var menu = MenuBuilder.satellitesMenu(startIndex);
                var index = menu.findItemById(getPropertyNumber("Satellites", 1));
                if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { index--; }
                menu.setFocus(index);
                WatchUi.switchToView(menu, new SatellitesMenuDelegate(), WatchUi.SLIDE_LEFT);
                break;
            case :theme:
                var theme = getPropertyNumber("Theme", 1);
                if(theme == 0) {
                    Application.Properties.setValue("Theme", 1);
                } else {
                    Application.Properties.setValue("Theme", 0);
                }
                
                renderLayout.update();
                renderValues.update();
                renderTitles.update();

                var menu1 = MenuBuilder.mainMenu(startIndex);
                var index1 = menu1.findItemById(:theme);
                if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { index1--; }
                menu1.setFocus(index1);
                WatchUi.switchToView(menu1, self, WatchUi.SLIDE_IMMEDIATE);
                break;
            case :autopause:
                Application.Properties.setValue("Autopause", item.isEnabled());
                sessionData.updateSettings();
                break;
            case :backlight:
                var backlight = getPropertyFloat("Backlight", 0.0);
                if(backlight == 0.0) {
                    Application.Properties.setValue("Backlight", 1.0);
                } else {
                    Application.Properties.setValue("Backlight", 0.0);
                }
                
                var menu2 = MenuBuilder.mainMenu(startIndex);
                var index2 = menu2.findItemById(:backlight);
                if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { index2--; }
                menu2.setFocus(index2);
                WatchUi.switchToView(menu2, self, WatchUi.SLIDE_IMMEDIATE);
                break;
            case :gesture:
                Application.Properties.setValue("DisableGesture", item.isEnabled());
                break;
            case :lap:
                WatchUi.switchToView(MenuBuilder.lapMenu(startIndex), new LapMenuDelegate(), WatchUi.SLIDE_LEFT);
                break;
            case :paceunits:
                var paceunits = getPropertyBoolean("PaceUnits500", false);
                Application.Properties.setValue("PaceUnits500", !paceunits);

		        sessionData.updateSettings();

                

                var menu3 = MenuBuilder.mainMenu(startIndex);
                var index3 = menu3.findItemById(:paceunits);
                if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { index3--; }
                menu3.setFocus(index3);
                WatchUi.switchToView(menu3, self, WatchUi.SLIDE_IMMEDIATE);
                break;
            case :about:
                WatchUi.pushView(new AboutView(), new BehaviorDelegate(), WatchUi.SLIDE_LEFT);
        }
    }


    public function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_BLINK);
    }
}