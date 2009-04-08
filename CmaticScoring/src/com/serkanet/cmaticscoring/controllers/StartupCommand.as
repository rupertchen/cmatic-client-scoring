package com.serkanet.cmaticscoring.controllers {
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class StartupCommand extends SimpleCommand {

		override public function execute(notification:INotification):void {
			trace("Running startup command");
		}

	}
}