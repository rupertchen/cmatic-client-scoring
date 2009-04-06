package com.serkanet.trial.scoringdataentry.models.vos {

	[Bindable]
	public class ScoringVo {

		public var id:String;
		public var order:Number;
		public var name:String;
		public var score1:Number;
		public var score2:Number;
		public var time:Number;
		public var timeDeduction:Number;
		public var otherDeduction:Number;
		public var finalScore:Number;
		public var tieBreaker1:Number;
		public var tieBreaker2:Number;
		public var tieBreaker3:Number;

		public function ScoringVo(
			id:String,
			order:Number,
			name:String,
			score1:Number = 0,
			score2:Number = 0,
			time:Number = 0,
			timeDeduction:Number = 0,
			otherDeduction:Number = 0,
			finalScore:Number = 0,
			tieBreaker1:Number = 0,
			tieBreaker2:Number = 0,
			tieBreaker3:Number = 0
		) {
			this.id = id;
			this.order = order;
			this.name = name;
			this.score1 = score1;
			this.score2 = score2;
			this.time = time;
			this.timeDeduction = timeDeduction;
			this.otherDeduction = otherDeduction;
			this.finalScore = finalScore;
			this.tieBreaker1 = tieBreaker1;
			this.tieBreaker2 = tieBreaker2;
			this.tieBreaker3 = tieBreaker3;
		}
	}
}