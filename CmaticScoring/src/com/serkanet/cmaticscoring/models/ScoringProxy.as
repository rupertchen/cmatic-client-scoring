package com.serkanet.cmaticscoring.models {

	import com.serkanet.cmaticscoring.models.vos.ScoringVo;

	import mx.events.PropertyChangeEvent;
	import mx.rpc.IResponder;

	import org.puremvc.as3.patterns.proxy.Proxy;


	public class ScoringProxy extends Proxy implements IResponder {

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
			if (scoring.isNandu) {
				scoring.finalScore = getNanduMeritedScore() - getTotalDeductions();
				scoring.tieBreaker1 = 0;
				scoring.tieBreaker2 = 0;
				scoring.tieBreaker3 = 0;
			} else {
				scoring.finalScore = getStandardMeritedScore() - getTotalDeductions();
				scoring.tieBreaker1 = computeTieBreaker1();
				scoring.tieBreaker2 = computeTieBreaker2();
				scoring.tieBreaker3 = computeTieBreaker3();
			}
		}


		private function computeTieBreaker1():Number {
			// Greater is better
			// The -1 is used so all tiebreakers are "greater is better"
			return -1 * Math.abs(getMeanOfInvalidScores() - getStandardMeritedScore());
		}


		private function computeTieBreaker2():Number {
			// Greater is better
			return getMeanOfInvalidScores();
		}


		private function computeTieBreaker3():Number {
			// Greater is better
			return getLowerInvalidScore();
		}


		private function getMeanOfInvalidScores():Number {
			return roundScores((getLowerInvalidScore() + getUpperInvalidScore()) / 2);
		}


		private function getLowerInvalidScore():Number {
			var min:Number = NaN;
			for each (var score:Number in getStandardScores()) {
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


		private function getUpperInvalidScore():Number {
			var max:Number = NaN;
			for each (var score:Number in getStandardScores()) {
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


		private function getStandardMeritedScore():Number {
			var numNonZeroScores:Number = 0;
			var sum:Number = 0;
			for each (var score:Number in getStandardScores()) {
				if (score == 0) {
					continue;
				}
				numNonZeroScores += 1;
				sum += score;
			}

			if (numNonZeroScores < 3) {
				// Not enough numbers to determine a score.
				return 0;
			}

			return roundScores((sum - getLowerInvalidScore() - getUpperInvalidScore()) / (numNonZeroScores - 2));
		}


		private function getNanduMeritedScore():Number {
			var sum:Number = 0;
			for each (var score:Number in getNanduScores()) {
				sum += score;
			}

			return sum  / 2;
		}


		private function roundScores(score:Number):Number {
			return Math.round(score * 1000) / 1000;
		}


		private function getTotalDeductions():Number {
			return scoring.timeDeduction + scoring.otherDeduction;
		}


		public function result(resultData:Object):void {
			trace("Scoring proxy succesful save");
			scoring.needsSaving = false;
		}


		public function fault(data:Object):void {
			trace("Scoring proxy failed save");
		}


		public function onChange(event:PropertyChangeEvent):void {
			switch (event.property) {
				case "score1":
				case "score2":
				case "score3":
				case "score4":
				case "score5":
				case "score6":
				case "timeDeduction":
				case "otherDeduction":
					computeScore();
					break;
			}

			if (event.property != "needsSaving") {
				scoring.needsSaving = true;
			}
		}


		private function getStandardScores():Array {
			return [
				scoring.score1,
				scoring.score2,
				scoring.score3,
				scoring.score4,
				scoring.score5
			];
		}


		private function getNanduScores():Array {
			return [
				scoring.score1,
				scoring.score2,
				scoring.score3,
				scoring.score4,
				scoring.score5,
				scoring.score6
			];
		}

	}
}
