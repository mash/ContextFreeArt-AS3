package jp.maaash.contextfreeart {

	public class Adjustment{
        public var name :String;
        public var flipDefined :Boolean = false;
        public var flip :Number;
        public var sizeX :Number = 1;
        public var sizeY :Number = 1;
        public var rotate :Number = 0;
        public var x :Number = 0;
        public var y :Number = 0;
        public var hue :Number = 0;
        public var saturation :Number = 0;
        public var brightness :Number = 0;
        public var alpha :Number = 0;

		public function Adjustment() {
		}
        public function fill( obj :Object ) :void {
            for( var key :String in obj ){
                switch( key ) {
                    case "f":
                    case "flip":
                        flipDefined = true;
                        flip = obj[key];
                        break;
                    case "s":
                    case "size":
                        var size :* = obj[key];
                        if ( typeof(size) == "number" ) { size = [size,size]; }
                        sizeX = size[0];
                        sizeY = size[1];
                        break;
                    case "r":
                        rotate     = obj[key];
                        break;
                    case "h":
                        hue        = obj[key];
                        break;
                    case "sat":
                        saturation = obj[key];
                        break;
                    case "b":
                        brightness = obj[key];
                        break;
                    case "a":
                        alpha      = obj[key];
                        break;
                    case "rotate":
                    case "x":
                    case "y":
                    case "hue":
                    case "saturation":
                    case "brightness":
                    case "alpha":
                        this[key] = obj[key];
                        break;
                    default:
                        throw("unsupported adjustment: "+key);
                }
            }
            
        }

	}
}
