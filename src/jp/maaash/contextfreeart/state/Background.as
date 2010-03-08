package jp.maaash.contextfreeart.state {
    import jp.maaash.contextfreeart.Compiler;
    import jp.maaash.contextfreeart.Adjustment;

	public class Background extends AbstractArgument {

		public function Background() {
		}

        override protected function onDone( obj :Object ) :Array {
            var adj :Adjustment = new Adjustment;
            adj.fill( obj );
            compiler.compiled[ "background" ] = adj;
            compiler = null;
            return [ "general" ];
        }
	}
}
