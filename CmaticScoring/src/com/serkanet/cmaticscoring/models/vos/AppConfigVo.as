package com.serkanet.cmaticscoring.models.vos {
	import org.puremvc.as3.utilities.flex.config.model.ConfigVO;

	public class AppConfigVo extends ConfigVO {

		public var ringNumber:Number;

		override public function isValid():Boolean {
			if (!super.isValid()) {
				return false;
			}
			return getService != null;
		}


		public function get getService():String {
			return config.nsDeploy::getService;
		}


		public function get setService():String {
			return config.nsDeploy::setService;
		}

	}
}
