package ;

import barcode.Barcode;
import haxe.Timer;
import haxekit.display.AutoScalingMainSprite;
import haxekit.general.Logger;
import haxekit.ui.Color;
import flash.events.Event;
import native_platform.event.MobileKeyboardPopupEvent;
import native_platform.NativePlatform;
import flash.events.FocusEvent;
import flash.Lib;


class Main extends AutoScalingMainSprite
{
    public static function main()
    {
        NativePlatform.Initialize();
        Barcode.Initialize();
        //NativePlatform.Instance().ShowPhoneStatusBar(true);
        
        // Reduce flicker of phone status bar disappear/reappear
        Timer.delay(function() {
            AutoScalingMainSprite.Initialize(new Main(), Layout.SCREEN_WIDTH, Layout.SCREEN_HEIGHT, AutoScalingMainSpriteScaleToWidth); 
            Logger.SetLoggerMinimumLogLevel(LogLevel.Debug);
        }, 100);
    }
    
    private override function OnInitComplete() : Void
    {
        m_output = new Output();
        m_output.y = Layout.SCREEN_HEIGHT - m_output.height;
        addChild(m_output);
        
        AddButton(new Button("ScanBarcode()", new Color(255, 200, 0), function() { Barcode.Instance().ScanBarcode(); } ));
        
        stage.addEventListener(Event.RESIZE, function(e) { m_output.Write("Resize (w=" + stage.stageWidth + ", h=" + stage.stageHeight + ", sx=" + this.scaleX + ", sy=" + this.scaleY + ")"); } );        
        stage.addEventListener(Event.ACTIVATE, function(e) { m_output.Write("Activate"); } );        
        stage.addEventListener(Event.DEACTIVATE, function(e) { m_output.Write("Deactivate"); } );        
    }    
    
    private function AddButton(btn:Button) : Void
    {
        if (m_curX + btn.width > Layout.SCREEN_WIDTH)
        {
            m_curX = 10;
            m_curY += btn.height + 10;
        }        
        
        btn.x = m_curX;
        btn.y = m_curY;
        addChild(btn);
        
        m_curX += btn.width + 10;
    }
    
    private var m_curX:Float = 10;
    private var m_curY:Float = 10;
    private var m_output:Output;
}
