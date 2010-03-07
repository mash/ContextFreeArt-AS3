package jp.maaash.contextfreeart.state {
    import jp.maaash.contextfreeart.Compiler;

	public class Rule implements IState {

		public function Rule(){

		}
        public function eat( token :String, compiler :Compiler ) :Array {
            var ruleName :String = token;

            // Create a blank rule if it doesn't aleady exist
            if ( ! compiler.compiled[ ruleName ] ) {
                compiler.compiled[ ruleName ] = [];
            }
            return [ "ruleWeight", ruleName ];
        }
	}
}
