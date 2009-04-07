package com.serkanet.trial.scoringdataentry.models {

	public class FormsProxy extends EventParameterProxyBase {

		public static const NAME:String = "Forms";
		public static const LOAD_SUCCESS:String = NAME + "/load/success";
		public static const LOAD_FAILURE:String = NAME + "/load/failure";

		private static const TYPE:String = "form";

		public function FormsProxy() {
			super(NAME, TYPE, LOAD_SUCCESS, LOAD_FAILURE);
		}

	}
}
