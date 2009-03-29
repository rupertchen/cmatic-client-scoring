package com.serkanet.trial.ringeventlist.models.vo {

	[Bindable]
	public class EventVO {

		public var id:String;
		public var code:String;
		public var name:String;
		public var numCompetitors:Number;


		public function EventVO(
			id:String,
			code:String,
			name:String,
			numCompetitors:Number
		) {
			this.id = id;
			this.code = code;
			this.name = name;
			this.numCompetitors = numCompetitors;
		}

	}
}