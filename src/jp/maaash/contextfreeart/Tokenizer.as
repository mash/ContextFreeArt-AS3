package jp.maaash.contextfreeart {

	public class Tokenizer{
        private var input :String;
        private const stopChars :Array = [" ", "{", "}", "\n", "\r", "\t"];

		public function Tokenizer() {
		}

        // TODO: String comments
        // TODO: Handle ordered arguments (i.e., square brakets)
        // TODO: Handle the | operator
        public function tokenize( _input :String ) :Array {
            input = _input;

            // To make it easier to parse, we pad the brackets with spaces.
            input = input.replace( /([{}])/g, " $1");
  
            var tokens :Array = new Array;
  
            var head :Object = { lastPos: 0 };
            while( 1 ) {
                head = tokenizeNext( head.lastPos );
  
                if ( head == null ) { break; }
  
                if ( head.token ) {
                    tokens.push( head.token );
                }
  
            }

            logger("[tokenize]tokens: ",tokens);
  
            return tokens;
        }

        private function tokenizeNext( pos :Number ) :Object {
            var stops :Array = new Array;

            var len :int = stopChars.length;
            for ( var i:int=0; i<len; i++ ) {
                var stopChar :String = stopChars[ i ];
                var foundPos :int    = input.indexOf( stopChar, pos );
                if ( foundPos != -1 ) {
                    stops.push( foundPos + 1 );
                }
            }

            if ( stops.length == 0 ) { return null; }
  
            var stopPos :Number = Math.min.apply( null, stops );
  
            var token :String   = input.substr(pos, stopPos-pos);
  
            // Remove whitespace characters as they can't be
            // tokens. Brackets can be tokens, so those don't
            // get removed.
            token = token.replace( /[ \n\r\t]/, "" );
  
            return { token: token, lastPos: stopPos }
        }

		private function logger(... args) :void {
			if ( 0 ) { 
				return; 
			}
			log.apply(null, (new Array("[Tokenizer]", this)).concat(args));
		}
	}
}
