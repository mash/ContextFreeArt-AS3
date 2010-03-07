package jp.maaash {
    import flash.display.DisplayObjectContainer;
    import jp.maaash.contextfreeart.Tokenizer;
    import jp.maaash.contextfreeart.Compiler;
    import jp.maaash.contextfreeart.Renderer;
    public class ContextFreeArt {
        public function ContextFreeArt( cfdg_text :String, container :DisplayObjectContainer ) {
            var t :Tokenizer = new Tokenizer;
            var tokens :Array = t.tokenize( cfdg_text );

            var c :Compiler = new Compiler;
            var compiled :Object = c.compile( tokens );

            logger("compiled: ",compiled);

            var r :Renderer = new Renderer( container.width, container.height );
            r.clearQueue();
            r.render( compiled, container );
        }

		private function logger(... args) :void {
			if ( 0 ) {
				return; 
			}
			log.apply(null, (new Array("[ContextFreeArt]", this)).concat(args));
		}
    }
}
