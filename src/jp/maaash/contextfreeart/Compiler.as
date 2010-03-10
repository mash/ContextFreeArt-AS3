package jp.maaash.contextfreeart {
    import jp.maaash.contextfreeart.state.*;
    import flash.utils.getDefinitionByName;

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
            var classObject :Class = getDefinitionByName( "jp.maaash.contextfreeart.state." + className ) as Class;

            if ( state_and_args.length > 0 ) {
                state = new classObject( state_and_args );
            }
            else {
                state = new classObject;
            }
        }

        private var stateGeneral :General;
        private var stateStartshape :Startshape;
        private var stateBackground :Background;
        private var stateRule :Rule;
        private var stateRuleWeight :RuleWeight;
        private var stateRuleDraw :RuleDraw;
        private var stateShape :ShapeAdjustment;

		private function logger(... args) :void {
			if ( 1 ) { 
				return; 
			}
			log.apply(null, (new Array("[compiler]", this)).concat(args));
		}
	}
}
