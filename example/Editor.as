package {
    import jp.maaash.ContextFreeArt;
    import flash.display.*;
    import flash.events.Event;
    import com.bit101.components.*;

	public class Editor extends Sprite{
        private var container :Sprite;

		public function Editor(){
            container = new Sprite;
            container.x = 400;
            addChild( container );
            
            var txt :Text = new Text( this );
            txt.width  = 400;
            txt.height = 460;
            var btn :PushButton = new PushButton( this, 0, 460, 'render', function() :void {
                cleanup();

                var cfdg :String = txt.text;
                container.addChild( new ContextFreeArt( cfdg ) );
            });
            btn.width  = 400;
            btn.height = 20;
		}

        private function cleanup() :void {
            while( container.numChildren ) {
                container.removeChildAt( 0 );
            }
        }
	}
}
