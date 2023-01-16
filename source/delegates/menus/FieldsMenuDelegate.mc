import Toybox.WatchUi;
import Toybox.Lang;

public class FieldsMenuDelegate extends WatchUi.Menu2InputDelegate {
    
    private var fieldId;
    private var pageId;

    public function initialize(mPageId, mFieldId) {
        Menu2InputDelegate.initialize();
        pageId = mPageId;
        fieldId = mFieldId;
    }

    public function onSelect(item) {
        Application.Properties.setValue(pageId.toString() + fieldId.toString(), item.getId());
        onBack();   
    }

    public function onBack() {
        var menu = MenuBuilder.pageMenu(0, pageId);
        var index = menu.findItemById(fieldId);
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { index--; }
        menu.setFocus(index);
        WatchUi.switchToView(menu, new PageMenuDelegate(pageId), WatchUi.SLIDE_RIGHT);
        return true;
    }
}