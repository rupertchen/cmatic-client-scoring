package com.serkanet.trial.scoringdataentry.models {
	import com.serkanet.trial.scoringdataentry.models.vos.ScoringVo;

	import mx.events.PropertyChangeEvent;

	import org.puremvc.as3.patterns.proxy.Proxy;


	public class ScoringProxy extends Proxy {

		public static const NAME:String = "ScoringProxy";


		public static function getName(id:String):String {
			return NAME + id;
		}


		public function ScoringProxy(scoring:ScoringVo) {
			super(getName(scoring.id), scoring);
		}


		public function get scoring():ScoringVo {
			return data as ScoringVo;
		}


		public function computeScore():void {
			computeFinalScore();
			computeTieBreaker1();
			computeTieBreaker2();
			computeTieBreaker3();
		}


		private function computeFinalScore():void {
			scoring.finalScore = meritedScore - totalDeductions;
		}


		private function computeTieBreaker1():void {
			// Greater is better
			// The -1 is used so all tiebreakers are "greater is better"
			scoring.tieBreaker1 = -1 * Math.abs(meanOfInvalidScores() - meritedScore);
		}


		private function computeTieBreaker2():void {
			// Greater is better
			scoring.tieBreaker2 = meanOfInvalidScores();
		}


		private function computeTieBreaker3():void {
			// Greater is better
			scoring.tieBreaker3 = lowerInvalidScore;
		}


		private function meanOfInvalidScores():Number {
			return (lowerInvalidScore + upperInvalidScore) / 2;
		}


		private function get lowerInvalidScore():Number {
			var min:Number = NaN;
			for each (var score:Number in scores) {
				if (score == 0) {
					continue;
				}
				if (isNaN(min)) {
					min = score;
				} else {
					min = Math.min(min, score);
				}
			}

			return min;
		}


		private function get upperInvalidScore():Number {
			var max:Number = NaN;
			for each (var score:Number in scores) {
				if (score == 0) {
					continue;
				}
				if (isNaN(max)) {
					max = score;
				} else {
					max = Math.max(max, score);
				}
			}

			return max;
		}


		private function get meritedScore():Number {
			var nonZeroCount:Number = 0;
			var sum:Number = 0;
			for each (var score:Number in scores) {
				if (score == 0) {
					continue;
				}
				nonZeroCount += 1;
				sum += score;
			}

			if (nonZeroCount < 3) {
				// Not enough numbers to determine a score.
				return NaN;
			}

			return (sum - lowerInvalidScore - upperInvalidScore) / (nonZeroCount - 2);
		}


		private function get totalDeductions():Number {
			return scoring.timeDeduction + scoring.otherDeduction;
		}


		public function save():void {
			trace("Saving scoring (" + scoring.id + ") back to server with final score (" + scoring.finalScore + ")");
			scoring.needsSaving = false;
		}


		public function onChange(event:PropertyChangeEvent):void {
			switch (event.property) {
				case "score1":
				case "score2":
				case "score3":
				case "score4":
				case "score5":
				case "timeDeduction":
				case "otherDeduction":
					computeScore();
					break;
			}

			if (event.property != "needsSaving") {
				scoring.needsSaving = true;
			}
		}


		private function get scores():Array {
			return [
				scoring.score1,
				scoring.score2,
				scoring.score3,
				scoring.score4,
				scoring.score5
			];
		}
	}
}