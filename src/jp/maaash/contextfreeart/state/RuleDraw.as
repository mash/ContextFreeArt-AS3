package jp.maaash.contextfreeart.state {
    import jp.maaash.contextfreeart.Compiler;

	public class RuleDraw implements IState {
        private var weight :Number = 1;
        private var ruleName :String;

		public function RuleDraw( args :Array ) {
            ruleName = args[0];
		}
        public function eat( token :String, compiler :Compiler ) :Array {
            if( token == "}" ){
                return [ "general" ];
            }
        
            return [ "shapeAdjustment", token, ruleName ];
        }
	}
}
