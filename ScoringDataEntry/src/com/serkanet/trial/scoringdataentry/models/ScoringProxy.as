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


		public function computeFinalScore():void {
			scoring.finalScore = meritedScore - totalDeductions;
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