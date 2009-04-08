package com.serkanet.cmaticscoring.views {
	import com.serkanet.cmaticscoring.ApplicationFacade;
	import com.serkanet.cmaticscoring.models.AgeGroupsProxy;
	import com.serkanet.cmaticscoring.models.DivisionsProxy;
	import com.serkanet.cmaticscoring.models.EventsProxy;
	import com.serkanet.cmaticscoring.models.FormsProxy;
	import com.serkanet.cmaticscoring.models.SexesProxy;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.utilities.flex.config.model.ConfigProxy;


	public class ApplicationMediator extends Mediator {

		public static const NAME:String = "ApplicationMediator";

		public static const ID_SCREEN:Number = 1;
		public static const LOADING_SCREEN:Number = 2;
		public static const MAIN_SCREEN:Number = 3;
		public static const ERROR_SCREEN:Number = 4;

		// TODO: This must be manually kept in sync with the number of prefetches in PrefetchDataCommand.
		// Factor this out into a separate prefetch proxy so the command can set the number at the same
		// place it does the loads.
		private static const TOTAL_PREFETCHES:Number = 5;
		private var numPrefetched:Number;


		public function ApplicationMediator(viewComponent:CmaticScoring) {
			super(NAME, viewComponent);

			facade.registerMediator(new IdScreenMediator(app.idScreen));
			facade.registerMediator(new MainScreenMediator(app.mainScreen));
		}


		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.VIEW_ID_SCREEN,
				ApplicationFacade.VIEW_MAIN_SCREEN,

				ConfigProxy.FAILURE,
				ConfigProxy.SUCCESS,
				AgeGroupsProxy.LOAD_SUCCESS,
				DivisionsProxy.LOAD_SUCCESS,
				FormsProxy.LOAD_SUCCESS,
				SexesProxy.LOAD_SUCCESS,
				EventsProxy.LOAD_SUCCESS,

				ApplicationFacade.PREFETCH_DATA
			];
		}


		override public function handleNotification(notification:INotification):void {
			// Cases are sorted in the order we expect them
			switch (notification.getName()) {
				case ApplicationFacade.VIEW_ID_SCREEN:
					app.viewStack.selectedIndex = ID_SCREEN;
					break;
				case ConfigProxy.SUCCESS:
					numPrefetched = 0;
					sendNotification(ApplicationFacade.PREFETCH_DATA);
					break;
				case ConfigProxy.FAILURE:
					app.viewStack.selectedIndex = ERROR_SCREEN;
					break;
				case ApplicationFacade.PREFETCH_DATA:
					app.viewStack.selectedIndex = LOADING_SCREEN;
					break;
				case DivisionsProxy.LOAD_SUCCESS:
				case SexesProxy.LOAD_SUCCESS:
				case AgeGroupsProxy.LOAD_SUCCESS:
				case FormsProxy.LOAD_SUCCESS:
				case EventsProxy.LOAD_SUCCESS:
					trace("Got some prefetch: " + notification.getName());
					numPrefetched++;
					if (isPrefetchDone()) {
						sendNotification(ApplicationFacade.VIEW_MAIN_SCREEN);
					}
					break;
				case ApplicationFacade.VIEW_MAIN_SCREEN:
					app.viewStack.selectedIndex = MAIN_SCREEN;
					break;
			}
		}


		private function get app():CmaticScoring {
			return viewComponent as CmaticScoring;
		}


		private function isPrefetchDone():Boolean {
			return TOTAL_PREFETCHES == numPrefetched;
		}

	}
}
