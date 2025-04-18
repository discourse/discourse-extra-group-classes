import Component from "@ember/component";
import { action, computed } from "@ember/object";
import { service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

export default class ExtraGroupClassesGroupEdit extends Component {
  @service dialog;

  tokenSeparator = "|";

  @computed("group.extra_classes")
  get extraClasses() {
    if (this.group.extra_classes) {
      return this.group.extra_classes
        .split(this.tokenSeparator)
        .filter(Boolean);
    }
    return null;
  }

  @action
  extraGroupClassesChanged(value) {
    let newValue = value.join(this.tokenSeparator);
    let group = this.group;
    let oldValue = this.group.extra_classes;

    group.set("extra_classes", newValue);

    return ajax(`/admin/groups/${group.id}/extra_classes`, {
      type: "PUT",
      data: group.getProperties("extra_classes"),
    }).catch(() => {
      group.set("extra_classes", oldValue);
      this.dialog.alert(
        i18n("generic_error_with_reason", {
          error: i18n("extra_group_classes.save_error"),
        })
      );
    });
  }
}
