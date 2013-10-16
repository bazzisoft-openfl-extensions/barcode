package barcode.event;
import flash.events.Event;


class BarcodeScannedEvent extends Event
{
    public static inline var BARCODE_SCANNED = "barcode_scanned";
    
    public var barcodeType(default, null) : String;
    public var barcodeValue(default, null) : String;
    
    public function new(type:String, barcodeType:String, barcodeValue:String)
    {
        super(type, true, true);
        
        this.barcodeType = barcodeType;
        this.barcodeValue = barcodeValue;
    }
}