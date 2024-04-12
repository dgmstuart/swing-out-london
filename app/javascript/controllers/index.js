import { application } from "./application"

import MapController from "./map_controller"
application.register("map", MapController)

import MapMenuController from "./map_menu_controller"
application.register("map-menu", MapMenuController)
