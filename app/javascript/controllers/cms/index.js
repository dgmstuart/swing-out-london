import { application } from "../application"

import EventFormController from "./event_form_controller"
application.register("event-form", EventFormController)

import CheckboxGuardedField from "./checkbox_guarded_field_controller"
application.register("checkbox-guarded-field", CheckboxGuardedField)

import FlashController from "./flash_controller"
application.register("flash", FlashController)

import OrganiserLinkController from "./organiser_link_controller"
application.register("organiser-link", OrganiserLinkController)
