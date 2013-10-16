package ;
import flash.text.TextFieldType;
import haxekit.display.TextFieldDefinition;
import haxekit.display.TextFieldFactory;
import haxekit.ui.Color;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;


class Output extends Sprite
{
    private static inline function TEXTDEF() { return new TextFieldDefinition( { fontId:"font/Gotham-Black.ttf", fontSize:24, fontColor:Color.BLACK(), maxWidth:Layout.SCREEN_WIDTH, textAlign:TextAlignment.Left } ); }
    
    public function new() 
    {
        super();
        
        var buttonShape = new Shape();
        var g = buttonShape.graphics;
        g.beginFill(Color.WHITE().AsInt());
        g.drawRect(0, 0, Layout.SCREEN_WIDTH, Layout.SCREEN_HEIGHT/3);
        g.endFill();
        addChild(buttonShape);
        
        var labelText = TextFieldFactory.Create(TEXTDEF());
        labelText.multiline = true;
        labelText.wordWrap = true;
        labelText.text = "Output:\n";
        labelText.height = buttonShape.height;
        labelText.type = TextFieldType.INPUT;
        labelText.mouseEnabled = true;
        addChild(labelText);
        m_text = labelText;
    }
    
    public function Write(txt:String)
    {
        m_text.appendText(txt);
        m_text.appendText("\n");
        m_text.scrollV = m_text.maxScrollV;
    }
    
    private var m_text:TextField;
}
