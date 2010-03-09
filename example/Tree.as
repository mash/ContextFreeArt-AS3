package {
    import jp.maaash.ContextFreeArt;
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

	public class Tree extends Sprite{

		public function Tree(){

            var loader :URLLoader = new URLLoader;
            var req    :URLRequest = new URLRequest( '/tree.cfdg' );
            loader.load( req );
            loader.addEventListener( Event.COMPLETE, function(e :Event) :void {
                var cfdg :String = loader.data;
                start( cfdg );
            });

		}
        private function start( cfdg :String ) :void {
            var art :ContextFreeArt = new ContextFreeArt( cfdg, this );

            stage.addEventListener( MouseEvent.CLICK, function(ev:MouseEvent) :void {
                art.tick();
            });
        }
	}
}
