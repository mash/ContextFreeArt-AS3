package jp.maaash {
    import flash.display.DisplayObjectContainer;
    import jp.maaash.contextfreeart.Tokenizer;
    import jp.maaash.contextfreeart.Compiler;
    import jp.maaash.contextfreeart.Renderer;
    public class ContextFreeArt {
        private var renderer :Renderer;

        public function ContextFreeArt( cfdg_text :String, container :DisplayObjectContainer ) {
            var t :Tokenizer = new Tokenizer;
            var tokens :Array = t.tokenize( cfdg_text );

            var c :Compiler = new Compiler;
            var compiled :Object = c.compile( tokens );

            logger("compiled: ",compiled);

            renderer = new Renderer( container.width, container.height );
            renderer.clearQueue();
            renderer.render( compiled, container );
        }

        public function tick() :void {
            renderer.tick();
        }

		private function logger(... args) :void {
			if ( 0 ) {
				return; 
			}
			log.apply(null, (new Array("[ContextFreeArt]", this)).concat(args));
		}
    }
}
