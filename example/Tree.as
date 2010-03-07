package {
    import jp.maaash.ContextFreeArt;
    import flash.display.*;
    import flash.events.MouseEvent;

	public class Tree extends Sprite{

		public function Tree(){
//             var cfdg :String = <><![CDATA[
// startshape Tree
// rule Tree {
//     CIRCLE { s .5 1.2 }
//     Tree { s .97 y .3 r 3}
// }
//                                     ]]></>;

//             var cfdg :String = <><![CDATA[
// startshape Tree
// rule Tree {
//     CIRCLE { s .5 1.2 }
//     Tree { s .95 y .3 r 3}
// }
// rule Tree .2 { 
//     Tree { flip 90 } }
// rule Tree .2 { 
//     Tree { r 10 } 
//     Tree { r -30 s .6} }
//                                     ]]></>;

//             var cfdg :String = <><![CDATA[
// startshape primitive
// rule primitive {
//   TRIANGLE {}
// }
//                                     ]]></>;

            var cfdg :String = <><![CDATA[
startshape FOREST

rule FOREST {
    SEED {}
    SEED {x -20}
    SEED {x -40}
}

rule SEED {BRANCH {}}
rule SEED {BRANCH {rotate 2}}
rule SEED {BRANCH {rotate -2}}
rule SEED {FORK {}}

rule BRANCH {LEFTBRANCH {flip 90}}
rule BRANCH {LEFTBRANCH {}}

rule LEFTBRANCH 4 {BLOCK {} LEFTBRANCH {y 0.9 rotate 0.1 size 0.95}}
rule LEFTBRANCH 4 {BLOCK {} LEFTBRANCH {y 0.9 rotate 0.2 size 0.95}}
rule LEFTBRANCH {BLOCK {} LEFTBRANCH {y 0.9 rotate 4 size 0.95}}
rule LEFTBRANCH {BLOCK {} FORK {}}

rule BLOCK {
    SQUARE {}
}

rule FORK {
    BRANCH { }
    BRANCH {size 0.5 rotate 40}
}

                                    ]]></>;

            var art :ContextFreeArt = new ContextFreeArt( cfdg, this );

            stage.addEventListener( MouseEvent.CLICK, function(ev:MouseEvent) :void {
                art.tick();
            });
		}
	}
}
