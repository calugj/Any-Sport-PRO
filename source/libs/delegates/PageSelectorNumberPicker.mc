import Toybox.WatchUi;
import Toybox.Lang;

public class PageSelector extends CustomNumberPickerDelegate {
    
    public function initialize(mView , mInitialValue as Number, mMIN_VAL as Number, mMAX_VAL as Number) {
        CustomNumberPickerDelegate.initialize(mView, mInitialValue, mMIN_VAL, mMAX_VAL);
    }

    //public function getValue() {}

    public function onBack() as Boolean {
        var menu = MenuBuilder.pageSelectorMenu(0);
        var index = menu.findItemById(:numberofpages);
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { index--; }
        menu.setFocus(index);
        WatchUi.switchToView(menu, new PageSelectorMenuDelegate(), WatchUi.SLIDE_RIGHT);

    }
    
    public function onConfirm() as Void {
        Application.Properties.setValue("NumberOfPages", getValue());
        onBack();
    }

}