package com.serkanet.trial.scoringdataentry.models {

	public class AgeGroupsProxy extends EventParameterProxyBase {

		public static const NAME:String = "AgeGroups";
		public static const LOAD_SUCCESS:String = NAME + "/load/success";
		public static const LOAD_FAILURE:String = NAME + "/load/failure";

		private static const TYPE:String = "ageGroup";

		public function AgeGroupsProxy() {
			super(NAME, TYPE, LOAD_SUCCESS, LOAD_FAILURE);
		}

	}
}
