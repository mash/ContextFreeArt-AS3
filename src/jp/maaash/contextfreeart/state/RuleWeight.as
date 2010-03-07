package jp.maaash.contextfreeart.state {
    import jp.maaash.contextfreeart.Compiler;

	public class RuleWeight implements IState {
        private var weight :Number = 1;
        private var ruleName :String;

		public function RuleWeight( args :Array ) {
            ruleName = args[0];
		}
        public function eat( token :String, compiler :Compiler ) :Array {
            if ( token != "{" ) {
                weight = parseFloat( token );
                return null;
            }
            else {
                // "{"
                compiler.compiled[ ruleName ].push({ weight: weight, draw: [] });
                return [ "ruleDraw", ruleName ];
            }
        }
	}
}
