package jp.maaash.contextfreeart.state {
    import jp.maaash.contextfreeart.Compiler;

	public class General implements IState {

		public function General(){

		}
        public function eat( token :String, compiler :Compiler ) :Array {
            return [ token ];
        }
	}
}
