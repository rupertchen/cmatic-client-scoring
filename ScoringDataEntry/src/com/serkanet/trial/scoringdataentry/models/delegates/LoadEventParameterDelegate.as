package com.serkanet.trial.scoringdataentry.models.delegates {
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;

	public class LoadEventParameterDelegate {

		private var service:HTTPService;
		private var parameters:Object;


		public function LoadEventParameterDelegate(url:String, type:String) {
			service = new HTTPService();
			service.url = url;
			service.resultFormat = "text";

			parameters = new Object();
			parameters.type = type;
		}


		public function retrieve(responder:IResponder):void {
			service.send(parameters).addResponder(responder);
		}

	}
}
