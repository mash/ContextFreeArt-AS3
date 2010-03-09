package jp.maaash.contextfreeart {
    import flash.display.DisplayObjectContainer;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.Graphics;
    import flash.events.TimerEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Timer;

	public class Renderer{
        private var width  :Number = 640;
        private var height :Number = 480;
        private var globalScale :Number = 300;

        private var centeringScale  :Number = 1;
        private var centeringMatrix :Matrix = new Matrix;

        private var queue :Array;
        private var compiled :Object;
        private var container :Sprite;
        private var background :Sprite;
        private var isRendering :Boolean = false;
        private var maxThreads :int = 1000;
        private var tickTimer :Timer;

		public function Renderer( _width :Number = 0, _height :Number = 0 ){
            if ( _width  ) { width  = _width;  }
            if ( _height ) { height = _height; }

            logger("w: "+width+" h: "+height);
		}

        public function render( _compiled :Object, _container :DisplayObjectContainer ) :void {
            compiled   = _compiled;
            background = new Sprite;
            _container.addChild( background );
            container  = new Sprite;
            _container.addChild( container );

            if ( ! queue ) { queue = new Array; }

            drawBackground();
            draw();

            tickTimer = new Timer( 30 );
            tickTimer.addEventListener( TimerEvent.TIMER, tick );
            tickTimer.start();
        }

        public function tick( e :TimerEvent = null ) :void {

            //while ( queue.length > 0 ) {
            if ( queue.length > 0 ) {
                isRendering = true;

                var concurrent :int = Math.min( queue.length - 1, maxThreads );

                for ( var i :int=0; i <= concurrent; i++ ) {
                    var args :Array = queue.shift();
                    drawRule.apply( null, args );
                }
                center();
            }

        }

        private function center() :void {

            var rect :Rectangle = container.getRect( container );

            // resize
            centeringScale    = Math.min( width / rect.width, height / rect.height ) * 0.9;
            centeringMatrix.a = centeringMatrix.d = centeringScale;

            // centering
            centeringMatrix.tx         = width /2 - (rect.left + rect.right ) / 2 * centeringScale;
            centeringMatrix.ty         = height/2 - (rect.top  + rect.bottom) / 2 * centeringScale;

            container.transform.matrix = centeringMatrix;

            //logger("[center]mtx,rect,container: ",centeringMatrix,rect,container);
        }

        private function draw() :void {
            var ruleName :String = compiled.startshape;
            var foregroundColor :Color = new Color;

            drawRule( ruleName, new Matrix, foregroundColor );
        }

        private function drawRule( ruleName :String, mtx :Matrix, color :Color, priority :Number = 0 ) :void {
            //logger("[drawRule]ruleName: "+ruleName+" mtx: ",mtx);

            // When things get too small, we can stop rendering.
            // Too small, in this case, means less than a pixel.
            if( Math.abs( mtx.a ) * globalScale * centeringScale < 1 && Math.abs( mtx.b ) * globalScale * centeringScale < 1 ){
                //logger("[drawRule]return");
                return;
            }

            var shape :Object = chooseShape( ruleName );
            drawShape( shape, mtx, color, priority );
        }

        private function chooseShape( ruleName :String ) :Object {
            // Choose which rule to go with...
            //logger("[chooseShape]ruleName: "+ruleName);

            var choices :Array = compiled[ ruleName ];
            if ( ! choices ) { throw("no rule found for "+ruleName); }

            var sum :Number = 0;
            for( var i :int=0; i<choices.length; i++) {
                sum += choices[i].weight;
            }

            var shape :Object;
            var r :Number = Math.random() * sum;
            sum = 0;
            for( i=0; i <= choices.length-1; i++) {
                sum += choices[i].weight;
                if( r <= sum ){
                    shape = choices[i];
                    break;
                }
            }
            if ( ! shape ) { throw("chooseShape failed, rule: "+ruleName+" invalid"); }

            return shape;
        }

        private function drawShape( shape :Object, mtx :Matrix, color :Color, priority :Number = 0 ) :void {

            //logger("[drawShape]shape: ",shape, mtx );

            var len :int = shape.draw.length;
            for ( var i :int = 0; i < len; i++ ) {
                var adj :Adjustment = shape.draw[ i ];

                var localTransform :Matrix = mtx.clone();
                localTransform             = adjustTransform( adj, localTransform );
                var localColor :Color     = adjustColor( adj, color );

                switch( adj.name ){
                    case "CIRCLE":
                        drawCIRCLE( localTransform, localColor );
                        break;
                        
                    case "SQUARE":
                        drawSQUARE( localTransform, localColor );
                        break;
                        
                    case "TRIANGLE":
                        drawTRIANGLE( localTransform, localColor );
                        break;
                        
                    default:
                        var args :Array = [ adj.name, localTransform, localColor ];
                          
                        if( priority == 1 ){ queue.unshift( args ); }
                        else{ queue.push( args ); }
                        
                        break;
                }
            }

        }

        private function drawCIRCLE( transform :Matrix, color :Color ) :void {
            var sh :Shape = new Shape;
            sh.graphics.beginFill.apply( null, colorToRgba(color) );
            sh.graphics.drawCircle( 0, 0, globalScale * 0.5 );
            sh.transform.matrix = transform;

            container.addChild( sh );
        }

        private function drawSQUARE( transform :Matrix, color :Color ) :void {
            var sh :Shape = new Shape;
            sh.graphics.beginFill.apply( null, colorToRgba( color ) );
            sh.graphics.drawRect( - globalScale * 0.5, - globalScale * 0.5, globalScale, globalScale );
            sh.transform.matrix = transform;

            container.addChild( sh );
        }

        private function drawTRIANGLE( transform :Matrix, color :Color ) :void {
            var sh :Shape = new Shape;
            sh.graphics.beginFill.apply( null, colorToRgba( color ) );

            // 1,2,sqrt(3)
            sh.graphics.drawTriangles(
                                      Vector.<Number>([
                                                       -globalScale * 0.5, Math.sqrt(3) * globalScale / 6,
                                                       +globalScale * 0.5, Math.sqrt(3) * globalScale / 6,
                                                       0,                  - Math.sqrt(3) * globalScale / 3]),
                                      Vector.<int>([0,1,2])
                                      );
            sh.transform.matrix = transform;

            container.addChild( sh );
        }

        private function drawBackground() :void {
            if ( compiled.background ) {
                var colorAdj :Adjustment = compiled.background;
                var backgroundColor :Color = new Color;
                backgroundColor.b = 1; // { h:0, s:0, b:1, a:1 };

                var color :Color = adjustColor( colorAdj, backgroundColor );
                var color_alpha :Array = colorToRgba( color );

                logger("[drawBackground]color: ",color, backgroundColor,color_alpha);

                var bg :Shape = new Shape;
                bg.graphics.beginFill( color_alpha[0], color_alpha[1] );
                bg.graphics.drawRect( 0, 0, width, height );
                background.addChild( bg );
            }
        }

        // order: move rotate scale
        private function adjustTransform( adjs :Adjustment, base :Matrix ) :Matrix {

            //logger("[adjustTransform][0]adjs: ",adjs," base: ",base);

            var mtx :Matrix = new Matrix;

            // Flip around a line through the origin;
            if ( adjs.flipDefined ){
                var flip :Number = adjs.flip;
                // Flip 0 means to flip along the X axis. Flip 90 means to flip along the Y axis.
                // That's why the flip vector (vX, vY) is Pi/2 radians further along than expected. 
                var vX :Number   = Math.cos( -2*Math.PI * flip / 360 );
                var vY :Number   = Math.sin( -2*Math.PI * flip / 360 );
                var norm :Number = 1/(vX*vX + vY*vY);
                //var flip :Matrix = new Matrix((vX*vX-vY*vY)/norm, 2*vX*vY/norm, 2*vX*vY/norm, (vY*vY-vX*vX)/norm, 0, 0);
                mtx.a = (vX*vX-vY*vY)/norm;
                mtx.b = 2*vX*vY/norm;
                mtx.c = 2*vX*vY/norm;
                mtx.d = (vY*vY-vX*vX)/norm;
            }

            // Scaling
            var sizeX :Number = adjs.sizeX;
            var sizeY :Number = adjs.sizeY;
            if ( sizeX || sizeY ) {
                mtx.scale( sizeX, sizeY );
            }

            // Rotation
            var r :Number = adjs.rotate;
            if ( r != 0 ) {
                mtx.rotate( - Math.PI * r / 180 );
            }

            // Tranalsation
            var x :Number =  adjs.x;
            var y :Number = -adjs.y;
            if ( x != 0 || y != 0 ) {
                var point :Point = new Point( x * globalScale, y * globalScale );
                mtx.translate( point.x, point.y );
            }

            mtx.concat( base );

            //logger("[adjustTransform][9]mtx: ",mtx);
            
            return mtx;
        }

        private function colorToRgba( color :Color ) :Array {
            return hsl2rgb( color.h, color.s, color.b, color.a );
        }

        // hue, saturation, brightness, alpha
        // hue: [0,360) default 0
        // saturation: [0,1] default 0
        // brightness: [0,1] default 1
        // alpha: [0,1] default 1
        private function hsl2rgb(h :Number, s :Number, l :Number, a :Number) :Array {

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
            //return "rgba(" + r + ", " + g + ", " + b + ", " + a + ")";

            // <uint>,<Number> to do: graphics.beginFill.apply( null, color.split(',') )
            return [ (r * 256*256 + g * 256 + b), a ];
        }

        // hsba to hsba
        private function adjustColor( adjs :Adjustment, color :Color ) :Color {
            // See http://www.contextfreeart.org/mediawiki/index.php/Shape_adjustments
            var newColor :Color = new Color;
            newColor.h = color.h;
            newColor.s = color.s;
            newColor.b = color.b;
            newColor.a = color.a;

            // Add num to the drawing hue value, modulo 360 
            newColor.h += adjs.hue;
            newColor.h %= 360;

            // If adj<0 then change the drawing [blah] adj% toward 0.
            // If adj>0 then change the drawing [blah] adj% toward 1. 
            if ( adjs.saturation != 0 ) {
                if( adjs.saturation > 0 ){
                    newColor.s += adjs.saturation * (1-color.s);
                } else {
                    newColor.s += adjs.saturation * color.s;
                }
            }
            if ( adjs.brightness != 0 ) {
                if( adjs.brightness > 0 ){
                    newColor.b += adjs.brightness * (1-color.b);
                } else {
                    newColor.b += adjs.brightness * color.b;
                }
            }
            if ( adjs.alpha != 0 ) {
                if( adjs.alpha > 0 ){
                    newColor.a += adjs.alpha * (1-color.a);
                } else {
                    newColor.a += adjs.alpha * color.a;
                }
            }
            
            return newColor;
        }

        public function clearQueue() :void {
            queue = new Array;
        }

		private function logger(... args) :void {
			if ( 0 ) {
				return; 
			}
			log.apply(null, (new Array("[Renderer]", this)).concat(args));
		}
	}
}
