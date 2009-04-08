package com.serkanet.cmaticscoring.models {

	public class SexesProxy extends EventParameterProxyBase {

		public static const NAME:String = "Sexes";
		public static const LOAD_SUCCESS:String = NAME + "/load/success";
		public static const LOAD_FAILURE:String = NAME + "/load/failure";

		private static const TYPE:String = "sex";


		public function SexesProxy() {
			super(NAME, TYPE, LOAD_SUCCESS, LOAD_FAILURE);
		}

	}
}
