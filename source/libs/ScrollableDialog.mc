/*
Description:
        A better dialog delegate that adapts the graphics to match Fenix 7 and Venu 2 latest user interface.
        The UI changes accordingly if the device has touchscreen or buttons.
Usage:  Create a MyCustomDialogDelegate class that extends CustomDialogDelegate
        Override the action methods
        push the view and the delegate
Methods to be overridden:
        CUstomDialog.setDisplayString
        CustomDialogDelegate.onBack() - not mandatory: the default action is -> WatchUi.popView(WatchUi.SLIDE_RIGHT);
        CustomDialogDelegate.onContinue()


Example of push call -> WatchUi.pushView(new CustomDialog("Continue"), new MyCustomDialogDelegate(), WatchUi.SLIDE_LEFT);
*/

import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

public class ScrollableDialog extends WatchUi.View {

    private var dialog as String = null;
    private var position;
    private var step;
    private var maxPosition;
    private var minPosition;
    
    public function initialize(mDialog as String) {
        View.initialize();

        dialog = mDialog;
    }

    public function onLayout(dc) {
        setDisplayString(dialog);
    }


    public function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);

        var foreground = Graphics.COLOR_WHITE;
        var background = Graphics.COLOR_BLACK;
        var width = dc.getWidth();
        var height = dc.getHeight();

        if(dc has :setAntiAlias) {
            dc.setAntiAlias(true);
        }
        dc.setColor(background, background);
        dc.clear();
        dc.setColor(foreground, background);
        dc.drawText(width/2, height/2 - position, Graphics.FONT_TINY, dialog, Graphics.TEXT_JUSTIFY_CENTER);


        dc.setPenWidth(width/80);
        dc.setColor(foreground, background);
        dc.drawArc(width/2, height/2, height/2*0.95, Graphics.ARC_COUNTER_CLOCKWISE, 23, 38);


        

        if(position != maxPosition) {
            dc.setColor(background, background);
            dc.fillRectangle(0, height*0.93, width, height*0.1);
            dc.setColor(foreground, foreground);


            var x = width*0.5;
            var y = height*0.98;
            var triangleOffset = width/32f;
            var coordinates = [ [-triangleOffset + x, -(triangleOffset/2) + y], [triangleOffset + x, -(triangleOffset/2) + y], [0 + x, triangleOffset/2 + y] ];
            dc.fillPolygon(coordinates);
        }
        
    }




    public function setDisplayString(mDialog as String) as Void {
        dialog = mDialog;

        var array = dialog.toCharArray();
        var counter = 1;
        for(var i = 0 ; i < array.size() ; i++) {
            if(array[i] == '\n') {
                counter++;
            }
        }

        minPosition = Graphics.getFontHeight(Graphics.FONT_TINY) / 2 ;
        maxPosition = counter * Graphics.getFontHeight(Graphics.FONT_TINY);
        step = Graphics.getFontHeight(Graphics.FONT_TINY) * 2;

        position = minPosition;

        WatchUi.requestUpdate();
    }





    public function decreasePosition() {
        position -= step;
        if(position < minPosition) {
            position = minPosition;
        }
        
        WatchUi.requestUpdate();
    }

    public function increasePosition() {
        position += step;
        if(position > maxPosition) {
            position = maxPosition;
        }

        WatchUi.requestUpdate();
    }
}





public class ScrollableDialogDelegate extends WatchUi.InputDelegate {

    private var view;

    public function initialize(mView) {
        InputDelegate.initialize();

        view = mView;
    }

    // Button devices
    public function onKey(keyEvent as WatchUi.KeyEvent) as Boolean {
        switch(keyEvent.getKey()) {
            case WatchUi.KEY_ENTER:
                onContinue();
                break;
            case WatchUi.KEY_ESC:
                onBack();
                break;
            case WatchUi.KEY_DOWN:
                onDown();
                break;
            case WatchUi.KEY_UP:
                onUp();
                break;
        }
        return true;
    }


    // Touch devices
    public function onTap(clickEvent as WatchUi.ClickEvent) as Boolean {
        var coordinates = clickEvent.getCoordinates();
        var height = System.getDeviceSettings().screenHeight;
        if( coordinates[1] >= height*0.9) {
            onDown();
            return true;
        }
        
        onContinue();
        return true;
    }

    public function onSwipe(swipeEvent as WatchUi.SwipeEvent) as Boolean {
        if(swipeEvent.getDirection() == WatchUi.SWIPE_RIGHT) {
            onBack();
        } else if(swipeEvent.getDirection() == WatchUi.SWIPE_DOWN) {
            onUp();
        } else if(swipeEvent.getDirection() == WatchUi.SWIPE_UP) {
            onDown();
        }
        return true;
    }



    private function onUp() {
        view.decreasePosition();
    }

    private function onDown() {
        view.increasePosition();
    }


    // This method may be overridden
    protected function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
    
    // This method must be overridden
    protected function onContinue() as Void {}

}