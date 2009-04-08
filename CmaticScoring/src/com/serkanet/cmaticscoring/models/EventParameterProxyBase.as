package com.serkanet.cmaticscoring.models {
	import com.serkanet.cmaticscoring.models.vos.EventParameterVo;


	public class EventParameterProxyBase extends CmaticDataProxyBase {

		public function EventParameterProxyBase(proxyName:String, proxyType:String, successNotification:String, failureNotification:String) {
			super(proxyName, proxyType, successNotification, failureNotification);
		}


		override protected function constructVo(record:Object):Object {
			var vo:EventParameterVo = new EventParameterVo();
			vo.id = record.id;
			vo.longName = record.longName;
			vo.shortName = record.shortName;
			return vo;
		}

	}
}
