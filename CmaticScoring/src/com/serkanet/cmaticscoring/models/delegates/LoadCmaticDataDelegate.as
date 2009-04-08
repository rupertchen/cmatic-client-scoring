package com.serkanet.cmaticscoring.models.delegates {
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;


	public class LoadCmaticDataDelegate {

		private var service:HTTPService;
		private var parameters:Object;


		public function LoadCmaticDataDelegate(url:String, type:String, filterField:String = null, filterValue:String = null) {
			service = new HTTPService();
			service.url = url;
			service.resultFormat = "text";

			parameters = new Object();
			parameters.type = type;
			if (filterField) {
				parameters.filterField = filterField;
				parameters.filterValue = filterValue;
			}
		}


		public function retrieve(responder:IResponder):void {
			service.send(parameters).addResponder(responder);
		}

	}
}
