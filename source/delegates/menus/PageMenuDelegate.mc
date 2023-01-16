import Toybox.WatchUi;
import Toybox.Lang;

public class PageMenuDelegate extends WatchUi.Menu2InputDelegate {
    
    private var pageId;

    public function initialize(mPageId) {
        Menu2InputDelegate.initialize();
        pageId = mPageId;
    }

    public function onSelect(item) {
        var startIndex = 0;
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { startIndex--; }

        if(item.getId() == :numberoffields) {
            var view = new CustomNumberPicker();
            var fieldsNumber = getPropertyNumber("FieldsPage" + pageId.toString(), 4);
            
            WatchUi.switchToView(view, new FieldsSelector(view, fieldsNumber, 1, 6, pageId), WatchUi.SLIDE_LEFT);
            return;
        }

        WatchUi.switchToView(MenuBuilder.fieldsMenu(startIndex), new FieldsMenuDelegate(pageId, item.getId()), WatchUi.SLIDE_LEFT);
        
    }

    public function onBack() {
        var menu = MenuBuilder.pageSelectorMenu(0);
        var index = menu.findItemById(pageId);
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { index--; }
        menu.setFocus(index);
        WatchUi.switchToView(menu, new PageSelectorMenuDelegate(), WatchUi.SLIDE_RIGHT);
        return true;
    }
}