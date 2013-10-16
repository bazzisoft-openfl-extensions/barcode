package barcode;

/**
 * Cross-platform interface to device specific functionality.
 */

interface IBarcodeImpl 
{
    function ScanBarcode() : Void;
}