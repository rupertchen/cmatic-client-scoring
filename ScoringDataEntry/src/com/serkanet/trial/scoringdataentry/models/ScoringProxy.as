package com.serkanet.trial.scoringdataentry.models {
	import com.serkanet.trial.scoringdataentry.models.vos.ScoringVo;

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
			// TODO: remove 0's from consideration
			return Math.min(scoring.score1, scoring.score2);
		}


		private function get upperInvalidScore():Number {
			// TODO: remove 0's from consideration
			return Math.max(scoring.score1, scoring.score2);
		}


		private function get meritedScore():Number {
			return (scoring.score1 + scoring.score2) / 2;
		}


		private function get totalDeductions():Number {
			return scoring.timeDeduction + scoring.otherDeduction;
		}


		public function save():void {
			trace("Saving scoring (" + scoring.id + ") back to server with final score (" + scoring.finalScore + ")");
		}

	}
}