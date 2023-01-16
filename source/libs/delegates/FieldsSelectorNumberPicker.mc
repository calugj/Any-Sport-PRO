import Toybox.WatchUi;
import Toybox.Lang;

public class FieldsSelector extends CustomNumberPickerDelegate {
    
    private var page;

    public function initialize(mView , mInitialValue as Number, mMIN_VAL as Number, mMAX_VAL as Number, mPage) {
        CustomNumberPickerDelegate.initialize(mView, mInitialValue, mMIN_VAL, mMAX_VAL);

        page = mPage;
    }

    //public function getValue() {}

    public function onBack() as Boolean {
        var menu = MenuBuilder.pageMenu(0, page);
        var index = menu.findItemById(:numberoffields);
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { index--; }
        menu.setFocus(index);
        WatchUi.switchToView(menu, new PageMenuDelegate(page), WatchUi.SLIDE_RIGHT);

    }
    
    public function onConfirm() as Void {
        Application.Properties.setValue("FieldsPage" + page, getValue());
        onBack();
    }

}