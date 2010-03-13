package jp.maaash.contextfreeart {
    import jp.maaash.contextfreeart.state.*;

	public class Compiler{
        private const keywords :Array = [ "startshape", "rule", "background" ];
        public var compiled :Object = {};
        public var state :IState;

        private var curKey :String;
        private var curValues :Array;
        private var obj :Object;

		public function Compiler(){
		}

        public function compile( tokens :Array ) :Object {
            state = new General;

            while ( tokens.length > 0 ) {
                var token :String = tokens.shift();
                var nextState :Array = state.eat( token, this );

                //logger("[compile]token: "+token+" nextState: "+nextState);

                if ( nextState ) {
                    next( nextState );
                }
            }
            return compiled;
        }

        private function next( state_and_args :Array ) :void {
            var className :String = state_and_args.shift();

            // uppercase the 1st char
            className = className.substr(0,1).toUpperCase() + className.substr(1);
            switch( className ) {
                case "Startshape":
                    state = new Startshape;
                    break;
                case "General":
                    state = new General;
                    break;
                case "Background":
                    state = new Background;
                    break;
                case "Rule":
                    state = new Rule;
                    break;
                case "RuleWeight":
                    state = new RuleWeight( state_and_args );
                    break;
                case "RuleDraw":
                    state = new RuleDraw( state_and_args );
                    break;
                case "ShapeAdjustment":
                    state = new ShapeAdjustment( state_and_args );
                    break;
                default:
                    throw('unknown className: '+className);
            }
        }

		private function logger(... args) :void {
			if ( 1 ) { 
				return; 
			}
			log.apply(null, (new Array("[compiler]", this)).concat(args));
		}
	}
}
