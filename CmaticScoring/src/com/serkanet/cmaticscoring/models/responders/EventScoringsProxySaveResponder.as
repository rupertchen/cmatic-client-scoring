package com.serkanet.cmaticscoring.models.responders {

	import com.serkanet.cmaticscoring.models.EventScoringsProxy;

	import mx.controls.Alert;
	import mx.rpc.IResponder;

	public class EventScoringsProxySaveResponder implements IResponder {

		private var proxy:EventScoringsProxy;


		public function EventScoringsProxySaveResponder(proxy:EventScoringsProxy) {
			this.proxy = proxy;
		}


		public function result(data:Object):void {
			proxy.resultSave(data);
		}


		public function fault(data:Object):void {
			proxy.faultSave(data);
		}

	}
}
