package {
    import jp.maaash.ContextFreeArt;
    import flash.display.*;
    import flash.events.MouseEvent;

	public class Tree extends Sprite{

		public function Tree(){
//             var cfdg :String = <><![CDATA[
// startshape Tree
// rule Tree {
//     CIRCLE { s .5 1.5 }
//     Tree { y .5 r 30 }
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

//             var cfdg :String = <><![CDATA[
// startshape FOREST

// rule FOREST {
//     SEED {}
//     SEED {x -20}
//     SEED {x -40}
// }

// rule SEED {BRANCH {}}
// rule SEED {BRANCH {rotate 2}}
// rule SEED {BRANCH {rotate -2}}
// rule SEED {FORK {}}

// rule BRANCH {LEFTBRANCH {flip 90}}
// rule BRANCH {LEFTBRANCH {}}

// rule LEFTBRANCH 4 {BLOCK {} LEFTBRANCH {y 0.9 rotate 0.1 size 0.95}}
// rule LEFTBRANCH 4 {BLOCK {} LEFTBRANCH {y 0.9 rotate 0.2 size 0.95}}
// rule LEFTBRANCH {BLOCK {} LEFTBRANCH {y 0.9 rotate 4 size 0.95}}
// rule LEFTBRANCH {BLOCK {} FORK {}}

// rule BLOCK {
//     SQUARE {}
// }

// rule FORK {
//     BRANCH { }
//     BRANCH {size 0.5 rotate 40}
// }

//                                     ]]></>;

//             var cfdg :String = <><![CDATA[
// startshape CHAPTER1

// rule CHAPTER1 {
//     SQUARE { x 2 y 5 size 3 }
//     CIRCLE { x 6 y 5 size 3 }
//     TRIANGLE { x 4 y 2 size 3 }
//     SHAPES { y 1 size 3 }
// }

// rule SHAPES {
//     SQUARE {}
//     CIRCLE {b 0.3}
//     TRIANGLE {b 0.5}
//     TRIANGLE {r 60 b 0.7}
// }

//                                     ]]></>;

            var cfdg :String = <><![CDATA[

startshape TOC

rule TOC {

    CHAPTER1 { x 0 y 0 }
    CHAPTER2 { x 10 y 0 }
    CHAPTER3 { x 0 y -10 }
    CHAPTER4 { x 10 y -10 }

}

rule CHAPTER1 {
    SQUARE { x 2 y 5 size 3 }
    CIRCLE { x 6 y 5 size 3 }
    TRIANGLE { x 4 y 2 size 3 }
    SHAPES { y 1 size 3 }
}

rule SHAPES {
    SQUARE {}
    CIRCLE {b 0.3}
    TRIANGLE {b 0.5}
    TRIANGLE {r 60 b 0.7}
}

rule CHAPTER2 {
    SQUARE { }
    SQUARE { x 3 y 7 }
    SQUARE { x 5 y 7 rotate 30 }
    SQUARE { x 3 y 5 size 0.75 }
    SQUARE { x 5 y 5
             brightness 0.5 }
    SQUARE { x 7 y 6
             r 45
             s 0.7
             b 0.7
    }

    FOURSQUARE { x 5 y 1
                 size 0.2 rotate 10 }
}
rule FOURSQUARE {
    SQUARE { x 0 y 0 size 5  3}
    SQUARE { x 0 y 5 size 2 4 }
    SQUARE { x 5 y 5 size 3 }
    SQUARE { x 5 y 0 size 2 }
}

rule CHAPTER3 {
    SPIRAL { x 0 y 3 }
}
rule SPIRAL {
    CIRCLE { size 0.5 }
    SPIRAL { y 0.2
         rotate -3
             size 0.995 }
}

rule CHAPTER4 {
    TREE { x 1 y 0 }
    TREE { x 6 y 0 }
    TREE { x 1 y 4 }
    TREE { x 6 y 4 }
}
rule TREE 20 {
    CIRCLE { size 0.25 }
    TREE { y 0.1 size 0.97 }
}
rule TREE 1.5 {
    BRANCH { }
}

rule BRANCH {
    BRANCH_LEFT { }
    BRANCH_RIGHT { }
}
rule BRANCH_LEFT {
    TREE { rotate 20 }
}
rule BRANCH_LEFT {
    TREE { rotate 30 }
}
rule BRANCH_LEFT {
    TREE { rotate 40 }
}
rule BRANCH_LEFT {
}

rule BRANCH_RIGHT {
    TREE { rotate -20 }
}
rule BRANCH_RIGHT {
    TREE { rotate -30 }
}
rule BRANCH_RIGHT {
    TREE { rotate -40 }
}
rule BRANCH_RIGHT {
}

                                    ]]></>;

            var art :ContextFreeArt = new ContextFreeArt( cfdg, this );

            stage.addEventListener( MouseEvent.CLICK, function(ev:MouseEvent) :void {
                art.tick();
            });
		}
	}
}
