package jp.maaash.contextfreeart.state {
    import jp.maaash.contextfreeart.Compiler;

	public class Startshape implements IState {

		public function Startshape() {

		}
        public function eat( token :String, compiler :Compiler ) :Array {
            // uppercase the 1st char
            compiler.compiled[ "startshape" ] = token;
            return [ "general" ];
        }
	}
}
