package com.serkanet.trial.scoringdataentry.controllers {
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class FailedConfigCommand extends SimpleCommand {

		override public function execute(notification:INotification):void {
			trace("configuration retieval failed");
		}

	}
}