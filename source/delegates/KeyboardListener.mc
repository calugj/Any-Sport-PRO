import Toybox.WatchUi;

public class KeyboardListener extends WatchUi.TextPickerDelegate {

    var text;
    var customizeDelegate;

    public function initialize(mCustomizeDelegate) {
        TextPickerDelegate.initialize();
        customizeDelegate = mCustomizeDelegate;
    }

    public function onTextEntered(mText, changed) {
        text = mText;
        if(changed) {
            Application.Properties.setValue("CustomActivityName1", mText.toString());
        }


        customizeDelegate.update();
        return true;
    }

    public function onCancel() {
        /*var menu = MenuBuilder.customizeMenu(0, text);
        var index = menu.findItemById(:name);
        menu.setFocus(index);
        WatchUi.pushView(menu, new CustomizeMenuDelegate(), WatchUi.SLIDE_RIGHT);*/
        return true;
    }
}