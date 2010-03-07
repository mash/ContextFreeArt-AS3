package jp.maaash.contextfreeart.state {
    import jp.maaash.contextfreeart.Compiler;

	public class Shape extends AbstractArgument {
        private var name :String;
        private var ruleName :String;

		public function Shape( args :Array ) {
            name     = args[0];
            ruleName = args[1];
		}

        override protected function onDone( obj :Object ) :Array {
            var shape :Object = { shape: name };
            for( var key :String in obj ){
                shape[key] = obj[key];
            }
            
            // We are always adding to the lastest rule we've created.
            var last :int = compiler.compiled[ ruleName ].length - 1;
            compiler.compiled[ ruleName ][ last ].draw.push( shape )

            compiler = null;
            return [ "ruleDraw", ruleName ];
        }
	}
}
