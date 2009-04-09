package com.serkanet.cmaticscoring.models.vos {

	[Bindable]
	public class EventVo {

		// Primary
		public var id:String;
		public var divisionId:String;
		public var sexId:String;
		public var ageGroupId:String;
		public var formId:String;
		public var code:String;
		public var ringId:String;
		public var order:Number;
		public var numCompetitors:Number;
		public var isFinished:Boolean;

		// Derived
		public var name:String;

	}
}
