package com.serkanet.trial.scoringdataentry.models {
	import com.serkanet.trial.scoringdataentry.models.vos.CompetitorVo;

	public class CompetitorsProxy extends CmaticDataProxyBase {

		public static const NAME:String = "Competitors";
		public static const LOAD_SUCCESS:String = NAME + "/load/success";
		public static const LOAD_FAILURE:String = NAME + "/load/failure";

		private static const TYPE:String = 'competitor';


		public function CompetitorsProxy() {
			super(NAME, TYPE, LOAD_SUCCESS, LOAD_FAILURE);
		}


		override protected function constructVo(record:Object):Object {
			var vo:CompetitorVo = new CompetitorVo();
			vo.id = record.id;
			vo.firstName = record.firstName;
			vo.lastName = record.lastName;
			return vo;
		}

	}
}