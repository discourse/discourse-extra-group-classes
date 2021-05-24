import Component from "@ember/component";
import { ajax } from "discourse/lib/ajax";
import { computed } from "@ember/object";
import bootbox from "bootbox";

export default Component.extend({
  tokenSeparator: "|",

  extraClasses: computed("group.extra_classes", function () {
    if (this.group.extra_classes) {
      return this.group.extra_classes
        .split(this.tokenSeparator)
        .filter(Boolean);
    }
    return null;
  }),

  actions: {
    extraGroupClassesChanged(value) {
      let newValue = value.join(this.tokenSeparator);
      let group = this.group;
      let oldValue = this.group.extra_classes;

      group.set("extra_classes", newValue);

      return ajax(`/admin/groups/${group.id}/extra_classes`, {
        type: "PUT",
        data: group.getProperties("extra_classes"),
      }).catch((e) => {
        group.set("extra_classes", oldValue);
        bootbox.alert(
          I18n.t("generic_error_with_reason", {
            error: I18n.t("extra_group_classes.save_error"),
          })
        );
      });
    },
  },
});
