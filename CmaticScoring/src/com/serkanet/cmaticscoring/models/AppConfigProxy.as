package com.serkanet.cmaticscoring.models {
	import com.serkanet.cmaticscoring.models.vos.AppConfigVo;

	import org.puremvc.as3.utilities.flex.config.interfaces.IConfigVO;
	import org.puremvc.as3.utilities.flex.config.model.ConfigProxy;

	public class AppConfigProxy extends ConfigProxy {

		public function AppConfigProxy() {
			super("cmatScoringConfig.xml");
		}


		override protected function constructVO():IConfigVO {
			return new AppConfigVo();
		}


		public function get appConfig():AppConfigVo {
			return super.configVO as AppConfigVo;
		}

	}
}
