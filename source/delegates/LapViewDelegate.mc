using Toybox.System;
using Toybox.WatchUi;
using Toybox.Lang;

public class LapViewDelegate extends WatchUi.BehaviorDelegate {
    
    public function initialize() {
        BehaviorDelegate.initialize();
    }
    
    public function onMenu() {
    	return true;
    }
    
    public function onSelect() {
        return true;
    }

    public function onBack() {
        return true;
    }
    
}