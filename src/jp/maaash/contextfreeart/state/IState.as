package jp.maaash.contextfreeart.state {
    import jp.maaash.contextfreeart.Compiler;

	public interface IState {

		function eat( token :String, compiler :Compiler ) :Array;
	}
}
