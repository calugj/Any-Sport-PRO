import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;

public class RenderTitles {
    
    private var height;
    private var width;
    private var screenShape;
    private var foregroundColor;
    private var textOffset;
    
    
    public function initialize() {
        height = System.getDeviceSettings().screenHeight;
        width = System.getDeviceSettings().screenWidth;
        screenShape = System.getDeviceSettings().screenShape;
    }


    public function update() {
        var theme = getPropertyNumber("Theme", 1);
        
        if(theme == 0) {
            foregroundColor = Graphics.COLOR_WHITE;
        } else {
            foregroundColor = Graphics.COLOR_BLACK;
        }

    }

    
    public function sixFields(dc as Graphics.DC, string as Array<String>) {
        textOffset = height/12;
        dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/8 - textOffset, Graphics.FONT_XTINY, string[0], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/4, height*3/8 - textOffset, Graphics.FONT_XTINY, string[1], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width*3/4, height*3/8 - textOffset, Graphics.FONT_XTINY, string[2], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/4, height*5/8 - textOffset, Graphics.FONT_XTINY, string[3], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width*3/4, height*5/8 - textOffset, Graphics.FONT_XTINY, string[4], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/2, height*7/8 - textOffset, Graphics.FONT_XTINY, string[5], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }


    public function fiveFields(dc as Graphics.DC, string as Array<String>) {
        textOffset = height/12;
        dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/8 - textOffset, Graphics.FONT_XTINY, string[0], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/2, height*3/8 - textOffset, Graphics.FONT_XTINY, string[1], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/4, height*5/8 - textOffset, Graphics.FONT_XTINY, string[2], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width*3/4, height*5/8 - textOffset, Graphics.FONT_XTINY, string[3], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/2, height*7/8 - textOffset, Graphics.FONT_XTINY, string[4], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }


    public function fourFields(dc as Graphics.DC, string as Array<String>) {
        textOffset = height/9;
        dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/6 - textOffset, Graphics.FONT_XTINY, string[0], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/4, height/2 - textOffset, Graphics.FONT_XTINY, string[1], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width*3/4, height/2 - textOffset, Graphics.FONT_XTINY, string[2], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/2, height*5/6 - textOffset, Graphics.FONT_XTINY, string[3], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }


    public function threeFields(dc as Graphics.DC, string as Array<String>) {
        textOffset = height/9;
        dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/6 - textOffset, Graphics.FONT_XTINY, string[0], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/2, height/2 - textOffset, Graphics.FONT_XTINY, string[1], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/2, height*5/6 - textOffset, Graphics.FONT_XTINY, string[2], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }


    public function twoFields(dc as Graphics.DC, string as Array<String>) {
        textOffset = height/10;
        dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/3 - textOffset, Graphics.FONT_XTINY, string[0], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/2, height*2/3 - textOffset, Graphics.FONT_XTINY, string[1], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }


    public function oneField(dc as Graphics.DC, string as Array<String>) {
        textOffset = height/5;
        dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/2 - textOffset, Graphics.FONT_XTINY, string[0], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}