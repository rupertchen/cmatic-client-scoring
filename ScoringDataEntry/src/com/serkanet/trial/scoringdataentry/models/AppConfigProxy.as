package com.serkanet.trial.scoringdataentry.models {
	import com.serkanet.trial.scoringdataentry.models.vos.AppConfigVo;

	import org.puremvc.as3.utilities.flex.config.interfaces.IConfigVO;
	import org.puremvc.as3.utilities.flex.config.model.ConfigProxy;

	public class AppConfigProxy extends ConfigProxy {

		public function AppConfigProxy() {
			super('appConfig.xml');
		}


		override protected function constructVO():IConfigVO {
			return new AppConfigVo();
		}


		public function get appConfig():AppConfigVo {
			return super.configVO as AppConfigVo;
		}

	}
}