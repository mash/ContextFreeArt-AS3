package jp.maaash.contextfreeart {
    import flash.display.DisplayObjectContainer;
    import flash.display.Shape;
    import flash.display.Graphics;

	public class Renderer{
        private var width :Number;
        private var height :Number;
        private var globalScale :Number = 300;

        private var queue :Array;
        private var compiled :Object;
        private var container :DisplayObjectContainer;

		public function Renderer( _width :Number = 640, _height :Number = 480 ){
            width  = _width;
            height = _height;
		}

        public function render( _compiled :Object, _container :DisplayObjectContainer ) :void {
            compiled = _compiled;
            container = _container;

            if ( ! queue ) { queue = new Array; }

            drawBackground();
            // setupEventHandlers
            draw();
        }

        private function draw() :void {
            var ruleName :String = compiled.startshape;
            var foregroundColor :Object = { h: 0, s: 0, b: 0, a: 1 };
            drawRule( ruleName, IdentityTransformation(), foregroundColor );
        }

        private function drawRule( ruleName :String, transform :Array, color :Object, priority :Number = 0 ) :void {
            // When things get too small, we can stop rendering.
            // Too small, in this case, means less than half a pixel.
            if( Math.abs( transform[0][1] ) * globalScale < .5 && Math.abs( transform[1][1] ) * globalScale < .5 ){
                return;
            }
                                      
            // Choose which rule to go with...
            var choices :Array = compiled[ ruleName ];

            var sum :Number = 0;
            for( var i :int=0; i<choices.length; i++) {
                sum += choices[i].weight;
            }

            var shape :String;
            var r :Number = Math.random() * sum;
            sum = 0;
            for( i=0; i <= choices.length-1; i++) {
                sum += choices[i].weight;
                if( r <= sum ){
                    shape = choices[i];
                    break;
                }
            }

            drawShape( shape, transform, color, priority );
        }

        private function drawShape( shape :Object, transform :Array, color :Object, priority :Number = 0 ) :void {
            var len :int = shape.draw.length;
            for ( var i :int = 0; i < len; i++ ) {
                var item :Object = shape.draw[i];

                var localTransform :Array = adjustTransform( item, transform );
                var localColor :Object = adjustColor( color, item );
                    
                switch( item.shape ){
                    case "CIRCLE":
//                         _draw( localTransform, function(ctx) {
//                             ctx.beginPath();
//                             ctx.fillStyle = colorToRgba( localColor );
//                             ctx.arc( 0, 0, .5, 0, 2*Math.PI, true )
//                             ctx.fill();
//                             ctx.closePath();
//                         });
                        break;
                        
                    case "SQUARE":
//                         _draw( localTransform, function(ctx) {
//                             ctx.beginPath();
//                             ctx.fillStyle = colorToRgba( localColor );
//                             ctx.fillRect(-.5, -.5, 1, 1);
//                             ctx.closePath();  
//                         });
                        break;
                        
                    case "TRIANGLE":
//                         _draw( localTransform, function(ctx) {
//                             ctx.beginPath();
//                             var scale = 0.57735; // Scales the side of the triagle down to unit length.
//                             ctx.moveTo( 0, -scale );
//                             for( var i=1; i<=3; i++ ){
//                                 ctx.lineTo( scale*Math.sin( i*2*Math.PI/3 ), -scale*Math.cos( i*2*Math.PI/3 ) );
//                             }
//                             ctx.fillStyle = colorToRgba( localColor );
//                             ctx.fill();
//                             ctx.closePath();            
//                         });
                        break;
                        
                    default:
//                         var threadedDraw = function(shape, transform, color){
//                             this.start = function(){
//                                 drawRule( shape, transform, color );
//                             }
//                         }
                          
//                         var tD :Object = new threadedDraw( item.shape, localTransform, localColor );
                          
//                         if( priority == 1 ){ queue.unshift(tD); }
//                         else{ queue.push( tD ); }
                        
                        break;
                }    
            }

        }

        private function _draw( transform :Array, drawFunc :Function ) :void {  
            // If this is a browser that supports transform and setTransform
            // we can use that. It's nice and fast. Currently, the only
            // browser to support this is Firefox 3.
//             if( Renderer.ctx.setTransform ) {
//                 Renderer.setTransform( transform );
//                 drawFunc( Renderer.ctx );
//                 return;
//             }
        }

        private function drawBackground() :void {
            if ( compiled.background ) {
                var colorAdj :Object  = compiled.background;
                var backgroundColor :Object = { h:0, s:0, b:1, a:1 };
                var color :Object = adjustColor( backgroundColor, colorAdj );

                var sh :Shape = new Shape;
                var gr :Graphics = sh.graphics;
                //gr.beginFill( );
                gr.drawRect( 0, 0, width, height );
            }
        }

        private function adjustTransform( adjs :Object, transform :Array ) :Array {
            // Tranalsation
            var x :Number =  getKeyValue( ["x"], 0, adjs );
            var y :Number = -getKeyValue( ["y"], 0, adjs );
            
            if( x != 0 || y != 0 ){
                var translate :Array = toAffineTransformation(1, 0, 0, 1, x, y);
                transform = compose( transform, translate );
            }

            // Rotation
            var r :Number = getKeyValue( ["r", "rotate"], 0, adjs );
            if ( r != 0 ) {
                var cosTheta :Number = Math.cos( -2*Math.PI * r/360 );
                var sinTheta :Number = Math.sin( -2*Math.PI * r/360 );
                var rotate :Array = toAffineTransformation( cosTheta, -sinTheta, sinTheta, cosTheta, 0, 0 );
                transform = compose( transform, rotate );
            }
            
            // Scaling
            var s :* = getKeyValue( ["s", "size"], 1, adjs );
            if( typeof(s) == "number" ){ s = [s,s]; }

            if( s != 1 ){
                var scale :Array = toAffineTransformation(s[0], 0, 0, s[1], 0, 0 );
                transform = compose( transform, scale );
            }
            
            // Flip around a line through the origin;
            var f :* = getKeyValue( ["f", "flip"], null, adjs );
            if( f != null ){
                // Flip 0 means to flip along the X axis. Flip 90 means to flip along the Y axis.
                // That's why the flip vector (vX, vY) is Pi/2 radians further along than expected. 
                var vX :Number = Math.cos( -2*Math.PI * f/360 );
                var vY :Number = Math.sin( -2*Math.PI * f/360 );
                var norm :Number = 1/(vX*vX + vY*vY);
                var flip :Array = toAffineTransformation((vX*vX-vY*vY)/norm, 2*vX*vY/norm, 2*vX*vY/norm, (vY*vY-vX*vX)/norm, 0, 0);
                transform = compose( transform, flip );
            }
            
            return transform;
            
        }

        private function colorToRgba( color :Object ) :String {
            return hsl2rgb( color.h, color.s, color.b, color.a );
        }

        // hue, saturation, brightness, alpha
        // hue: [0,360) default 0
        // saturation: [0,1] default 0
        // brightness: [0,1] default 1
        // alpha: [0,1] default 1
        private function hsl2rgb(h :Number, s :Number, l :Number, a :Number) :String {
            if (h == 360){ h = 0;}

            //
            // based on C code from http://astronomy.swin.edu.au/~pbourke/colour/hsl/
            //

            while (h < 0){ h += 360; }
            while (h > 360){ h -= 360; }
            var r :Number, g :Number, b :Number;
            if (h < 120){
                r = (120 - h) / 60;
                g = h / 60;
                b = 0;
            }else if (h < 240){
                r = 0;
                g = (240 - h) / 60;
                b = (h - 120) / 60;
            }else{
                r = (h - 240) / 60;
                g = 0;
                b = (360 - h) / 60;
            }

            r = Math.min(r, 1);
            g = Math.min(g, 1);
            b = Math.min(b, 1);

            r = 2 * s * r + (1 - s);
            g = 2 * s * g + (1 - s);
            b = 2 * s * b + (1 - s);

            if (l < 0.5){
                r = l * r;
                g = l * g;
                b = l * b;
            }else{
                r = (1 - l) * r + 2 * l - 1;
                g = (1 - l) * g + 2 * l - 1;
                b = (1 - l) * b + 2 * l - 1;
            }

            r = Math.ceil(r * 255);
            g = Math.ceil(g * 255);
            b = Math.ceil(b * 255);

            // Putting a semicolon at the end of an rgba definition
            // causes it to not work.
            return "rgba(" + r + ", " + g + ", " + b + ", " + a + ")";

        }

        // Composes two transformations (i.e., by multiplying them).
        private function compose(m1 :Array, m2 :Array) :Array {
            var result :Array = IdentityTransformation();

            for (var x :int= 0; x < 3; x++) {
                for (var y :int= 0; y < 3; y++) {
                    var sum :Number= 0;

                    for (var z :int= 0; z < 3; z++) {
                        sum += m1[x][z] * m2[z][y];
                    }

                    result[x][y] = sum;
                }
            }
            return result;
        }

        private function toAffineTransformation( a :Number, b :Number, c :Number, d :Number, x :Number, y :Number ) :Array {
            return [ [a,b,x], [c,d,y], [0,0,1] ];
        }

        private function IdentityTransformation() :Array {
            // 3x3 Matrix. This is the identity affine transformation.
            return [[1, 0, 0], [0, 1, 0], [0, 0, 1]];
        }

        private function adjustColor( color :Object, adjustments :Object ) :Object {
            // See http://www.contextfreeart.org/mediawiki/index.php/Shape_adjustments
            var newColor :Object = { h: color.h, s: color.s, b: color.b, a: color.a };
            
            // Add num to the drawing hue value, modulo 360 
            newColor.h += getKeyValue( ["h", "hue"], 0, adjustments );
            newColor.h %= 360;
            
            var adj :Object = {};
            adj.s = getKeyValue( ["sat", "saturation"], 0, adjustments )
            adj.b = getKeyValue( ["b", "brightness"], 0, adjustments )
            adj.a = getKeyValue( ["a", "alpha"], 0, adjustments )
            
            // If adj<0 then change the drawing [blah] adj% toward 0.
            // If adj>0 then change the drawing [blah] adj% toward 1. 
            for( var key :String in adj ) {
                if( adj[key] > 0 ){
                    newColor[key] += adj[key] * (1-color[key]);
                } else {
                    newColor[key] += adj[key] * color[key];
                }
            }
            
            return newColor;
        }

        // Used within a function to get an synonym'ed arguments value, or supply a default.
        // For example:
        //   var hue = getKeyValue( ["h", "hue"], 0, args );
        //   var x = getKeyValue( "x", 1, args );
        //
        private function getKeyValue( possibleVariableNames :Array, defaultValue :*, argList :Object ) :Number {
            // We can either be getting a list of strings or a string. If we get a string,
            // we just convert it into a list containing that string.
//             if( typeof(possibleVariableNames) == "string" ) {
//                 possibleVariableNames = [possibleVariableNames];
//             }

            for( var i :int=0; i<=possibleVariableNames.length-1; i++) {
                var name :String = possibleVariableNames[i];
                if( typeof(argList[name]) != "undefined" ) {
                    return argList[name];
                }
            }
  
            return defaultValue;
        }

        public function clearQueue() :void {
            queue = new Array;
        }
	}
}
