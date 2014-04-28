package barcode.event;
import flash.events.Event;


class BarcodeScannedEvent extends Event
{
    public static inline var BARCODE_SCANNED = "barcode_barcode_scanned";
    public static inline var BARCODE_SCAN_CANCELLED = "barcode_barcode_scan_cancelled";

    public var barcodeType(default, null) : String = null;
    public var barcodeValue(default, null) : String = null;

    public function new(type:String, ?barcodeType:String, ?barcodeValue:String)
    {
        super(type, true, true);

        this.barcodeType = barcodeType;
        this.barcodeValue = barcodeValue;
    }

	public override function clone() : Event
    {
		return new BarcodeScannedEvent(type, barcodeType, barcodeValue);
	}

	public override function toString() : String
    {
        var s = "[BarcodeScannedEvent type=" + type;
        if (type != BARCODE_SCAN_CANCELLED)
        {
            s += " barcodeType=" + barcodeType + " barcodeValue=" + barcodeValue;
        }
        s += "]";
        return s;
	}
}