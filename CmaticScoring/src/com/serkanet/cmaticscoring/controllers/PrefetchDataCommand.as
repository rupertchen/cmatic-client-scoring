package com.serkanet.cmaticscoring.controllers {
	import com.serkanet.cmaticscoring.models.AgeGroupsProxy;
	import com.serkanet.cmaticscoring.models.DivisionsProxy;
	import com.serkanet.cmaticscoring.models.FormsProxy;
	import com.serkanet.cmaticscoring.models.SexesProxy;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class PrefetchDataCommand extends SimpleCommand {

		override public function execute(notification:INotification):void {
			var divisions:DivisionsProxy = facade.retrieveProxy(DivisionsProxy.NAME) as DivisionsProxy;
			divisions.load();

			var sexes:SexesProxy = facade.retrieveProxy(SexesProxy.NAME) as SexesProxy;
			sexes.load();

			var ageGroups:AgeGroupsProxy = facade.retrieveProxy(AgeGroupsProxy.NAME) as AgeGroupsProxy;
			ageGroups.load();

			var forms:FormsProxy = facade.retrieveProxy(FormsProxy.NAME) as FormsProxy;
			forms.load();

		}

	}
}
