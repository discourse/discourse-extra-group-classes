import Component from "@ember/component";
import { classNames, tagName } from "@ember-decorators/component";
import ExtraGroupClassesGroupEdit from "../../components/extra-group-classes-group-edit";

@tagName("div")
@classNames("group-edit-outlet", "extra-group-classes")
export default class ExtraGroupClasses extends Component {
  <template><ExtraGroupClassesGroupEdit @group={{this.group}} /></template>
}
