import { computed } from "@ember/object";
import discourseComputed from "discourse-common/utils/decorators";
import { withPluginApi } from "discourse/lib/plugin-api";

// Takes a list of classes like my-class1|my-class2
// and returns an array of the form ["g-my-class1", "g-my-class2"]
function parseClasses(classList) {
  let prefix = "g-";
  let separator = "|";
  return classList.split(separator).map((c) => prefix + c);
}

export default {
  name: "extra-group-classes",
  initialize() {
    // decorate posts within topics
    withPluginApi("0.11.2", (api) => {
      api.includePostAttributes("extra_classes");
      api.addPostClassesCallback((attrs) => {
        if (attrs.extra_classes) {
          return parseClasses(attrs.extra_classes);
        }
      });

      api.modifyClass("component:user-card-contents", {
        @discourseComputed("user")
        extraClasses(user) {
          console.log(user);
          if (user && user.primary_group_extra_classes) {
            let classes = user.primary_group_extra_classes;
            classes = parseClasses(classes).join(" ");
            return classes;
          }
        },
        classNameBindings: ["extraClasses"],
      });

      // decorate group posts
      api.modifyClass("component:group-post", {
        extraClasses: computed(function () {
          if (this.post && this.post.extra_classes) {
            let classes = this.post.extra_classes;
            classes = parseClasses(classes).join(" ");
            return classes;
          }
        }),
        classNameBindings: ["extraClasses"],
      });
    });
  },
};
