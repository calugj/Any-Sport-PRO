import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.System;

class CustomNumberPicker extends WatchUi.View {

    private var number as Number;
    private var MIN_VAL as Number;
    private var MAX_VAL as Number;
    
    public function initialize() {
        View.initialize();

        number = 0;
        MIN_VAL = 0;
        MAX_VAL = 0;
    }

    public function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        var foreground = Graphics.COLOR_WHITE;
        var background = Graphics.COLOR_BLACK;
        var width = dc.getWidth();
        var height = dc.getHeight();
        var isTouchScreen = System.getDeviceSettings().isTouchScreen;

        if(dc has :setAntiAlias) {
            dc.setAntiAlias(true);
        }
        dc.setColor(foreground, background);
        dc.clear();
        dc.setColor(foreground, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/2, Graphics.FONT_NUMBER_MEDIUM, number, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);



        var triangleOffset = width/32f;
        
        if(number > MIN_VAL) {  // Show DOWN arrow
            var x = 0;
            var y = 0;
            if(isTouchScreen) {
                x = width/2;
                y = height*4/5;
            } else {
                x = width*0.14;
                y = height*0.72;
            }
            var coordinates = [ [-triangleOffset + x, -(triangleOffset/2) + y], [triangleOffset + x, -(triangleOffset/2) + y], [0 + x, triangleOffset/2 + y] ];
            dc.fillPolygon(coordinates);
        }
        if(number < MAX_VAL) {  // Show UP arrow
            var x = 0;
            var y = 0;
            if(isTouchScreen) {
                x = width/2;
                y = height/5;
            } else {
                x = width*0.09;
                y = height*0.5;
            }
            var coordinates = [ [-triangleOffset + x, (triangleOffset/2) + y], [triangleOffset + x, (triangleOffset/2) + y], [0 + x, -(triangleOffset/2) + y] ];
            dc.fillPolygon(coordinates);
        }

        dc.setPenWidth(width/80);
        dc.drawArc(width/2, height/2, height/2*0.95, Graphics.ARC_COUNTER_CLOCKWISE, 23, 38);

    }



    public function setNumber(mNumber as Number) as Void {
        number = mNumber;
    }

    public function setExtremes(mMIN_VAL as Number, mMAX_VAL as Number) as Void{
        MIN_VAL = mMIN_VAL;
        MAX_VAL = mMAX_VAL;
    }

}








public class CustomNumberPickerDelegate extends WatchUi.InputDelegate {

    public class RangeErrorException extends Lang.Exception {
        public function initialize() {
            Exception.initialize();
        }
    }
    
    private var view;
    private var number as Number;
    private var MIN_VAL as Number;
    private var MAX_VAL as Number;
    
    public function initialize(mView , mInitialValue as Number, mMIN_VAL as Number, mMAX_VAL as Number) {
        InputDelegate.initialize();

        if(mInitialValue > mMAX_VAL || mInitialValue < mMIN_VAL || mMIN_VAL > mMAX_VAL) {
            throw new RangeErrorException();
        }
        view = mView;
        
        number = mInitialValue;
        MIN_VAL = mMIN_VAL;
        MAX_VAL = mMAX_VAL;

        view.setNumber(number);
        view.setExtremes(MIN_VAL, MAX_VAL);
    }

    public function onKey(keyEvent) as Boolean {
        switch(keyEvent.getKey()) {
            case WatchUi.KEY_DOWN:
                onDown();
                break;
            case WatchUi.KEY_UP:
                onUp();
                break;
            case WatchUi.KEY_ENTER:
                onConfirm();
                break;
            case WatchUi.KEY_ESC:
                onBack();
                break;
        }
        return true;
    }

    public function onTap(clickEvent) as Boolean {
        var coordinates = clickEvent.getCoordinates();
        var width = System.getDeviceSettings().screenWidth;
        var height = System.getDeviceSettings().screenHeight;
        var offset = width / 19;
        if( (coordinates[0] - width/2).abs() <= offset && (coordinates[1] - height/5).abs() <= offset ) {
            onUp();
        } else if( (coordinates[0] - width/2).abs() <= offset && (coordinates[1] - height*4/5).abs() <= offset ) {
            onDown();
        }
        return true;
    }

    public function onSwipe(swipeEvent as WatchUi.SwipeEvent) as Boolean {
        if(swipeEvent.getDirection() == WatchUi.SWIPE_RIGHT) {
            onBack();
        }
        return true;
    }




    public function onDown() as Void {
        if(number - 1 < MIN_VAL) {
            return;
        }
        number -= 1;
        view.setNumber(number);
        WatchUi.requestUpdate();
        return;
    }

    public function onUp() as Void {
        if(number + 1 > MAX_VAL) {
            return;
        }
        number += 1;
        view.setNumber(number);
        WatchUi.requestUpdate();
        return;
    }

    



    public function getValue() as Number {
        return number;
    }

    // This method must be overridden
    protected function onConfirm() as Void {
        
    }

    // This method may be overridden
    protected function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }

}
