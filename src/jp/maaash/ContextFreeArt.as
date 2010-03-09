package jp.maaash {
    import flash.display.Sprite;
    import jp.maaash.contextfreeart.Tokenizer;
    import jp.maaash.contextfreeart.Compiler;
    import jp.maaash.contextfreeart.Renderer;

    public class ContextFreeArt extends Sprite {
        private var renderer :Renderer;

        public function ContextFreeArt( cfdg_text :String, width :Number = 640, height :Number = 480 ) {
            var t :Tokenizer = new Tokenizer;
            var tokens :Array = t.tokenize( cfdg_text );

            var c :Compiler = new Compiler;
            var compiled :Object = c.compile( tokens );

            logger("compiled: ",compiled);

            renderer = new Renderer( width, height );
            renderer.clearQueue();
            renderer.render( compiled, this );
        }

        public function tick() :void {
            renderer.tick();
        }

		private function logger(... args) :void {
			if ( 1 ) {
				return; 
			}
			log.apply(null, (new Array("[ContextFreeArt]", this)).concat(args));
		}
    }
}
