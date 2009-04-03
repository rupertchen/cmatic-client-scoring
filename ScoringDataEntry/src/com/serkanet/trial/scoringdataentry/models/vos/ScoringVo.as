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

		public function ScoringVo(
			id:String,
			order:Number,
			name:String,
			score1:Number,
			score2:Number,
			time:Number,
			finalScore:Number
		) {
			this.id = id;
			this.order = order;
			this.name = name;
			this.score1 = score1;
			this.score2 = score2;
			this.time = time;
			this.timeDeduction = 0;
			this.otherDeduction = 0;
			this.finalScore = finalScore;
		}
	}
}