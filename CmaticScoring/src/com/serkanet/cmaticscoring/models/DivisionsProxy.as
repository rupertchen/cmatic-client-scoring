package com.serkanet.cmaticscoring.models {
	import mx.collections.ArrayCollection;


	public class DivisionsProxy extends EventParameterProxyBase {

		public static const NAME:String = "Divisions";
		public static const LOAD_SUCCESS:String = NAME + "/load/success";
		public static const LOAD_FAILURE:String = NAME + "/load/failure";

		private static const TYPE:String = "division";


		public function DivisionsProxy() {
			super(NAME, TYPE, LOAD_SUCCESS, LOAD_FAILURE);
		}


		public function get divisions():ArrayCollection {
			return data as ArrayCollection;
		}

	}
}
