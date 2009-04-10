package com.serkanet.cmaticscoring.models.responders {

	import com.serkanet.cmaticscoring.models.EventsProxy;

	import mx.rpc.IResponder;


	public class EventsProxySaveResponder implements IResponder {

		private var proxy:EventsProxy;


		public function EventsProxySaveResponder(proxy:EventsProxy) {
			this.proxy = proxy;
		}


		public function result(data:Object):void {
			proxy.resultSave(data);
		}


		public function fault(info:Object):void {
			proxy.faultSave(info);
		}

	}
}
