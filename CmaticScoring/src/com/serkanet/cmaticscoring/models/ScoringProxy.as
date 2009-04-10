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
			computeFinalScore();
			computeTieBreaker1();
			computeTieBreaker2();
			computeTieBreaker3();
		}


		private function computeFinalScore():void {
			scoring.finalScore = getMeritedScore() - getTotalDeductions();
		}


		private function computeTieBreaker1():void {
			// Greater is better
			// The -1 is used so all tiebreakers are "greater is better"
			scoring.tieBreaker1 = -1 * Math.abs(getMeanOfInvalidScores() - getMeritedScore());
		}


		private function computeTieBreaker2():void {
			// Greater is better
			scoring.tieBreaker2 = getMeanOfInvalidScores();
		}


		private function computeTieBreaker3():void {
			// Greater is better
			scoring.tieBreaker3 = getLowerInvalidScore();
		}


		private function getMeanOfInvalidScores():Number {
			return roundScores((getLowerInvalidScore() + getUpperInvalidScore()) / 2);
		}


		private function getLowerInvalidScore():Number {
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


		private function getUpperInvalidScore():Number {
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


		private function getMeritedScore():Number {
			var numNonZeroScores:Number = 0;
			var sum:Number = 0;
			for each (var score:Number in scores) {
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
