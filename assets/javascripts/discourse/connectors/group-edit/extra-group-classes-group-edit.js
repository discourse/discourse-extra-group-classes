import { ajax } from "discourse/lib/ajax";
import { computed } from "@ember/object";

export default {
  tokenSeparator: "|",

  extraClasses: computed("group.extra_classes", function () {
    return this.model.extra_classes.split(this.tokenSeparator).filter(Boolean);
  }),

  actions: {
    extraGroupClassesChanged(value) {
      newValue = value.join(this.tokenSeparator);
      group.set("extra_classes", newValue);

      return ajax(`/admin/groups/${group.id}/extra_classes`, {
        type: "PUT",
        data: group.getProperties("extra_classes"),
      });
    },
  },
};
