import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;

public class RenderValues {
    
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

    public function sixFields(dc as Graphics.DC, value as Array<String>) {
        textOffset = height/13;
        dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/8 + textOffset/2, Graphics.FONT_NUMBER_MILD, value[0], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/4, height*3/8 + textOffset/2, Graphics.FONT_NUMBER_MILD, value[1], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width*3/4, height*3/8 + textOffset/2, Graphics.FONT_NUMBER_MILD, value[2], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/4, height*5/8 + textOffset/2, Graphics.FONT_NUMBER_MILD, value[3], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width*3/4, height*5/8 + textOffset/2, Graphics.FONT_NUMBER_MILD, value[4], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/2, height*7/8 + textOffset/2, Graphics.FONT_NUMBER_MILD, value[5], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }


    public function fiveFields(dc as Graphics.DC, value as Array<String>) {
        textOffset = height/18;
        dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/8 + textOffset/2, Graphics.FONT_NUMBER_MILD, value[0], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/2, height*3/8 + textOffset/2, Graphics.FONT_NUMBER_MILD, value[1], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/4, height*5/8 + textOffset/2, Graphics.FONT_NUMBER_MILD, value[2], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width*3/4, height*5/8 + textOffset/2, Graphics.FONT_NUMBER_MILD, value[3], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/2, height*7/8 + textOffset/2, Graphics.FONT_NUMBER_MILD, value[4], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }


    public function fourFields(dc as Graphics.DC, value as Array<String>) {
        textOffset = height/15;
        var font = Graphics.FONT_NUMBER_MEDIUM;
        if(dc.getWidth() < 215) {
            font = Graphics.FONT_NUMBER_MILD;
        }
        dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/6 + textOffset/2, font, value[0], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/4, height/2 + textOffset/2, font, value[1], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width*3/4, height/2 + textOffset/2, font, value[2], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/2, height*5/6 + textOffset/2, font, value[3], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }


    public function threeFields(dc as Graphics.DC, value as Array<String>) {
        textOffset = height/15;
        var font = Graphics.FONT_NUMBER_MEDIUM;
        if(dc.getWidth() < 215) {
            font = Graphics.FONT_NUMBER_MILD;
        }
        dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/6 + textOffset/2, font, value[0], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/2, height/2 + textOffset/2, font, value[1], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/2, height*5/6 + textOffset/2, font, value[2], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    public function twoFields(dc as Graphics.DC, value as Array<String>) {
        textOffset = height/11;
        var font = Graphics.FONT_NUMBER_MEDIUM;
        if(dc.getWidth() < 215) {
            font = Graphics.FONT_NUMBER_MILD;
        }
        dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/3 + textOffset/2, font, value[0], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/2, height*2/3 + textOffset/2, font, value[1], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }


    public function oneField(dc as Graphics.DC, value) {
        textOffset = 0;
        dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/2 + textOffset/2, Graphics.FONT_NUMBER_HOT, value[0], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

}