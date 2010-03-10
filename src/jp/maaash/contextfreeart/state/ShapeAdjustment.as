package jp.maaash.contextfreeart.state {
    import jp.maaash.contextfreeart.Compiler;
    import jp.maaash.contextfreeart.Adjustment;

	public class ShapeAdjustment extends AbstractArgument {
        private var name :String;
        private var ruleName :String;

		public function ShapeAdjustment( args :Array ) {
            name     = args[0];
            ruleName = args[1];
		}

        override protected function onDone( obj :Object ) :Array {
            trace(this + ".onDone(obj :Object ) : " + obj );
            var shape :Adjustment = new Adjustment();
            shape.name = name;
            shape.fill( obj );
            
            // We are always adding to the lastest rule we've created.
            var last :int = compiler.compiled[ ruleName ].length - 1;
            compiler.compiled[ ruleName ][ last ].draw.push( shape )

            compiler = null;
            return [ "ruleDraw", ruleName ];
        }
	}
}
