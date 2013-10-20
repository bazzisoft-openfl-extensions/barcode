package ;
import haxekit.display.TextFieldDefinition;
import haxekit.display.TextFieldFactory;
import haxekit.ui.Color;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;


class Button extends Sprite
{
    private static inline var BUTTON_WIDTH = 385;
    private static inline var BUTTON_HEIGHT = 140;
    
    private static inline function TEXTDEF() { return new TextFieldDefinition( { fontId:"font/Gotham-Black.ttf", fontSize:32, fontColor:Color.BLACK, maxWidth:BUTTON_WIDTH, textAlign:TextAlignment.Center } ); }
    
    public function new(label:String, color:Color, callbackFunc:Void -> Void) 
    {
        super();
        
        m_callbackFunc = callbackFunc;
        
        this.buttonMode = true;
        
        var buttonShape = new Shape();
        var g = buttonShape.graphics;
        g.beginFill(color.AsInt());
        g.drawRoundRect(0, 0, BUTTON_WIDTH, BUTTON_HEIGHT, 10, 10);
        g.endFill();
        addChild(buttonShape);
        
        var labelText = TextFieldFactory.Create(TEXTDEF());
        labelText.multiline = true;
        labelText.wordWrap = true;
        labelText.text = label;
        labelText.y = (BUTTON_HEIGHT - labelText.textHeight) / 2.0 - 3.0;
        labelText.height = BUTTON_HEIGHT - labelText.y;
        addChild(labelText);
        
        this.addEventListener(MouseEvent.CLICK, function(e) { m_callbackFunc(); } );
    }
    
    private var m_callbackFunc:Void -> Void;
}