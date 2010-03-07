package jp.maaash.contextfreeart.state {
    import jp.maaash.contextfreeart.Compiler;

	public class AbstractArgument implements IState {
        protected var curKey :String = null;
        protected var curValues :Array = [];
        protected var obj :Object = {};
        protected var compiler :Compiler;

		public function AbstractArgument(){

		}
        public function eat( token :String, _compiler :Compiler ) :Array {
            compiler = _compiler;

            switch ( token ) {
                case "}":
                    flushKey();
                    return onDone( obj );
                case "{":
                    return null;
            }

            // If it's a keyword name...
            if( token.match(/[a-z_]+/i) ) {
                flushKey();
                curKey = token;
                curValues = [];
            }
            // Otherwise it's a value (and hence a number)
            else {
                curValues.push( parseFloat(token) );
            }

            return null;
        }

        protected function onDone( obj :Object ) :Array { return null; } // abstract

        protected function flushKey() :void {
            if ( curKey ) {
                // If there is only one value for the key, we don't need to wrap
                // it in an array.
                if ( curValues.length == 1 ) {
                    obj[ curKey ] = curValues[0];
                }
                else {
                    obj[ curKey ] = curValues;
                }
            }
        }

	}
}
