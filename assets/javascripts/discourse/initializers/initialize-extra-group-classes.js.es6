import { computed } from "@ember/object";
import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "extra-group-classes",
  initialize() {
    let prefix = "g-";

    // decorate posts within topics
    withPluginApi("0.11.2", (api) => {
      api.includePostAttributes("extra_classes");
      api.addPostClassesCallback((attrs) => {
        if (attrs.extra_classes) {
          return attrs.extra_classes.split("|").map((c) => prefix + c);
        }
      });

      // decorate avatar classes
      api.customUserAvatarClasses((user) => {
        if (user.primary_group_extra_classes) {
          return user.primary_group_extra_classes
            .split("|")
            .map((c) => prefix + c);
        }
      });

      // decorate group posts
      api.modifyClass("component:group-post", {
        extraClasses: computed(function () {
          console.log(this);
          console.log(this.post);
          console.log(this.post.extra_classes);
          if (this.post && this.post.extra_classes) {
            let classes = this.post.extra_classes;
            classes = classes
              .split("|")
              .map((c) => prefix + c)
              .join(" ");
            console.log(classes);
            return classes;
          }
        }),
        classNameBindings: ["extraClasses"],
      });
    });
  },
};
