package jp.maaash.contextfreeart.state {
    import jp.maaash.contextfreeart.Compiler;

	public class Background extends AbstractArgument {

		public function Background() {
		}

        override protected function onDone( obj :Object ) :Array {
            compiler.compiled[ "background" ] = obj;
            compiler = null;
            return [ "general" ];
        }
	}
}
