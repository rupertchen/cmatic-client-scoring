package com.serkanet.trial.scoringdataentry.models.vos {
	import org.puremvc.as3.utilities.flex.config.model.ConfigVO;

	public class AppConfigVo extends ConfigVO {

		override public function isValid():Boolean {
			if (!super.isValid()) {
				return false;
			}
			return getService != null;
		}


		public function get getService():String {
			return config.nsDeploy::getService;
		}

	}
}