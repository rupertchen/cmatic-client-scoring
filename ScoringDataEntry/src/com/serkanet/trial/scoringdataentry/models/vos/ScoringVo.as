package com.serkanet.trial.scoringdataentry.models.vos {

	[Bindable]
	public class ScoringVo {

		public var id:String;
		public var order:Number;
		public var name:String;
		public var score1:Number;
		public var score2:Number;
		public var score3:Number;
		public var score4:Number;
		public var score5:Number;
		public var time:Number;
		public var timeDeduction:Number;
		public var otherDeduction:Number;
		public var finalScore:Number;
		public var tieBreaker1:Number;
		public var tieBreaker2:Number;
		public var tieBreaker3:Number;
		public var placement:Number;
		public var needsSaving:Boolean;

	}
}