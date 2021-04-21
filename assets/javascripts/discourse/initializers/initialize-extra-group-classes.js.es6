import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "extra-group-classes",
  initialize() {
    withPluginApi("0.11.2", (api) => {
      api.includePostAttributes("extra_classes");
      api.addPostClassesCallback((attrs) => {
        console.log(attrs);
        if (attrs.extra_classes) {
          return attrs.extra_classes.split("|");
        }
      });
    });
  },
};
