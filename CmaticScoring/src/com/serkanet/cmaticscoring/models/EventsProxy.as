package com.serkanet.cmaticscoring.models {
	import com.serkanet.cmaticscoring.models.vos.EventVo;


	public class EventsProxy extends CmaticDataProxyBase {

		public static const NAME:String = "Events";
		public static const LOAD_SUCCESS:String = NAME + "/load/success";
		public static const LOAD_FAILURE:String = NAME + "/load/failure";

		private static const TYPE:String = "event";


		public function EventsProxy() {
			super(NAME, TYPE, LOAD_SUCCESS, LOAD_FAILURE);
		}


		override protected function constructVo(record:Object):Object {
			var vo:EventVo = new EventVo();
			vo.id = record.id;
			vo.divisionId = record.divisionId;
			vo.sexId = record.sexId;
			vo.ageGroupId = record.ageGroupId;
			vo.formId = record.formId;
			vo.code = record.code;
			vo.ringId = record.ringId;
			vo.order = record.order;
			vo.numCompetitors = record.numCompetitors;
			vo.isFinished = record.isFinished;
			return vo;
		}

	}
}
