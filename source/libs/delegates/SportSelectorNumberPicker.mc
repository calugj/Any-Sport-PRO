import Toybox.WatchUi;
import Toybox.Lang;

public class SportSelector extends CustomNumberPickerDelegate {


    public function initialize(mView , mInitialValue as Number, mMIN_VAL as Number, mMAX_VAL as Number) {
        CustomNumberPickerDelegate.initialize(mView, mInitialValue, mMIN_VAL, mMAX_VAL);
    }

    //public function getValue() {}

    public function onBack() as Boolean {
        var menu = MenuBuilder.customizeMenu(0);
        var index = menu.findItemById(:sport);
        if(System.getDeviceSettings().isTouchScreen && !((System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) != 0)) { index--; }
        menu.setFocus(index);
        WatchUi.switchToView(menu, new CustomizeMenuDelegate(), WatchUi.SLIDE_RIGHT);
    }
    
    public function onConfirm() as Void {
        Application.Properties.setValue("CustomActivityType1", getValue());
        onBack();
    }

}