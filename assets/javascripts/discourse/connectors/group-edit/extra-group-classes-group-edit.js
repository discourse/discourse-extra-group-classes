import { ajax } from "discourse/lib/ajax";

export default {
  actions: {
    extraGroupClassesChanged(value) {
      group.set("extra_classes", value);

      return ajax(`/admin/groups/${group.id}/extra_classes`, {
        type: "PUT",
        data: group.getProperties("extra_classes"),
      });
    },
  },
};
