package {
    import jp.maaash.ContextFreeArt;
    import flash.display.*;

	public class Tree extends Sprite{

		public function Tree(){
            var cfdg :String = <><![CDATA[
startshape Tree
rule tree {
    CIRCLE { s .5 1.2 }
    tree { s .97 y .3 r 3}
}
rule tree .1 { 
    tree { flip 90 } }
rule tree .1 { 
    tree { r 10 } 
    tree { r -30 s .6} }
                                    ]]></>;

            var art :ContextFreeArt = new ContextFreeArt( cfdg, this );
		}
	}
}
