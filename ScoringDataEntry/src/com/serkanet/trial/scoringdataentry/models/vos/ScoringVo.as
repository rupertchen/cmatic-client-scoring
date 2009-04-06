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


		// TODO: For the "real" thing there's no point in doing this. Might as well just assign directly to the
		// members.
		public function ScoringVo(
			id:String,
			order:Number,
			name:String,
			score1:Number = 0,
			score2:Number = 0,
			score3:Number = 0,
			score4:Number = 0,
			score5:Number = 0,
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
			this.score3 = score3;
			this.score4 = score4;
			this.score5 = score5;
			this.time = time;
			this.timeDeduction = timeDeduction;
			this.otherDeduction = otherDeduction;
			this.finalScore = finalScore;
			this.tieBreaker1 = tieBreaker1;
			this.tieBreaker2 = tieBreaker2;
			this.tieBreaker3 = tieBreaker3;
			this.needsSaving = false;
			this.placement = 0;
		}
	}
}